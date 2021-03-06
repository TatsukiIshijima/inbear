import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/entity/image_entity.dart';
import 'package:inbear_app/entity/user_entity.dart';
import 'package:inbear_app/exception/auth/auth_exception.dart';
import 'package:inbear_app/exception/database/firestore_exception.dart';
import 'package:inbear_app/exception/storage/firebase_storage_exception.dart';
import 'package:inbear_app/repository/image_repository_impl.dart';
import 'package:inbear_app/repository/schedule_repository_impl.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/viewmodel/base_viewmodel.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../status.dart';

class AlbumStatus extends Status {
  AlbumStatus(String value) : super(value);

  static const noSelectScheduleError = Status('NO_SELECT_SCHEDULE_ERROR');
  static const permissionDeniedError = Status('PERMISSION_DENIED_ERROR');
  static const permissionPermanentlyDeniedError =
      Status('PERMISSION_PERMANENTLY_DENIED_ERROR');
  static const imageUploadError = Status('IMAGE_UPLOAD_ERROR');
  static const uploadImageSuccess = Status('UPLOAD_IMAGE_SUCCESS');
  static const fetchImagesSuccess = Status('FETCH_IMAGES_SUCCESS');
}

class AlbumViewModel extends BaseViewModel {
  final UserRepositoryImpl _userRepositoryImpl;
  final ScheduleRepositoryImpl _scheduleRepositoryImpl;
  final ImageRepositoryImpl _imageRepositoryImpl;

  AlbumViewModel(this._userRepositoryImpl, this._scheduleRepositoryImpl,
      this._imageRepositoryImpl);

  static const _originalUrlKey = 'original_url';
  static const _thumbnailUrlKey = 'thumbnail_url';

  final _imagesStreamController = StreamController<List<DocumentSnapshot>>();
  final List<DocumentSnapshot> _images = <DocumentSnapshot>[];
  final scrollController = ScrollController();

  Stream<List<DocumentSnapshot>> get imagesStream =>
      _imagesStreamController.stream;
  StreamSink<List<DocumentSnapshot>> get imagesSink =>
      _imagesStreamController.sink;

  DocumentSnapshot _lastSnapshot;
  bool isSelectedSchedule = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _imagesStreamController.close();
    imagesSink.close();
    scrollController.dispose();
    super.dispose();
  }

  void setScrollListener() {
    scrollController.addListener(() async {
      final maxScrollExtent = scrollController.position.maxScrollExtent;
      // GridView だと outOfRange が常に false
      // (スクロールの範囲がオーバーしない)ので条件には追加しない
      if (scrollController.offset >= maxScrollExtent && !_isLoading) {
        _isLoading = true;
        await _executeFetchImagesNext();
        _isLoading = false;
      }
    });
  }

  Future<void> executeUploadSelectImages() async {
    await executeFutureOperation(() => _uploadSelectImages());
  }

  Future<void> _uploadSelectImages() async {
    try {
      final user =
          await fromCancelable(_userRepositoryImpl.fetchUser()) as UserEntity;
      if (user.selectScheduleId.isEmpty) {
        throw NoSelectScheduleException();
      }
      final pickUpImages = await fromCancelable(MultiImagePicker.pickImages(
          maxImages: 5,
          enableCamera: false,
          materialOptions: MaterialOptions(
            statusBarColor: '#bf5f82',
            actionBarColor: '#f48fb1',
            actionBarTitleColor: '#ffffff',
            actionBarTitle: '写真',
          ))) as List<Asset>;
      if (pickUpImages.isEmpty) {
        status = Status.none;
        notifyListeners();
        return;
      }
      for (final image in pickUpImages) {
        final uploadUrls = await fromCancelable(
                _imageRepositoryImpl.uploadImage(user.selectScheduleId, image))
            as Map<String, String>;
        final imageEntity = ImageEntity(uploadUrls[_originalUrlKey],
            uploadUrls[_thumbnailUrlKey], user.uid, DateTime.now());
        await fromCancelable(
            _scheduleRepositoryImpl.postImage(
                user.selectScheduleId, imageEntity), onCancel: () {
          _imageRepositoryImpl.deleteImage(uploadUrls[_originalUrlKey]);
          _imageRepositoryImpl.deleteImage(uploadUrls[_thumbnailUrlKey]);
        });
      }
      status = AlbumStatus.uploadImageSuccess;
    } on NoSelectScheduleException {
      status = AlbumStatus.noSelectScheduleError;
    } on NoImagesSelectedException {
      status = Status.none;
    } on PermissionDeniedException {
      status = AlbumStatus.permissionDeniedError;
    } on PermissionPermanentlyDeniedExeption {
      status = AlbumStatus.permissionPermanentlyDeniedError;
    } on UploadImageException {
      status = AlbumStatus.imageUploadError;
    }
    notifyListeners();
  }

  Future<void> executeFetchImageAtStart() async {
    _lastSnapshot = null;
    await executeFutureOperation(() => _fetchImageAtStart());
  }

  Future<void> _fetchImageAtStart() async {
    try {
      if (_imagesStreamController.isClosed) {
        status = Status.none;
        notifyListeners();
        return;
      }
      final user =
          await fromCancelable(_userRepositoryImpl.fetchUser()) as UserEntity;
      if (user.selectScheduleId.isEmpty) {
        throw NoSelectScheduleException();
      }
      final imageDocuments = await fromCancelable(
              _scheduleRepositoryImpl.fetchImagesAtStart(user.selectScheduleId))
          as List<DocumentSnapshot>;
      if (imageDocuments.isEmpty) {
        throw NotRegisterAnyImagesException();
      }
      _images.clear();
      _images.addAll(imageDocuments);
      imagesSink.add(_images);
      _lastSnapshot = imageDocuments.last;
      status = AlbumStatus.fetchImagesSuccess;
    } on NoSelectScheduleException {
      imagesSink.addError(NoSelectScheduleException());
      status = Status.none;
    } on NotRegisterAnyImagesException {
      imagesSink.addError(NotRegisterAnyImagesException());
      status = Status.none;
    } on TimeoutException {
      imagesSink.addError(TimeoutException(''));
      status = Status.none;
    }
    notifyListeners();
  }

  Future<void> _executeFetchImagesNext() async {
    await executeFutureOperation(() => _fetchImagesNext());
  }

  Future<void> _fetchImagesNext() async {
    try {
      if (_imagesStreamController.isClosed || _lastSnapshot == null) {
        status = Status.none;
        notifyListeners();
        return;
      }
      final user =
          await fromCancelable(_userRepositoryImpl.fetchUser()) as UserEntity;
      if (user.selectScheduleId.isEmpty) {
        throw NoSelectScheduleException();
      }
      final imageDocuments = await fromCancelable(_scheduleRepositoryImpl
              .fetchImagesNext(user.selectScheduleId, _lastSnapshot))
          as List<DocumentSnapshot>;
      if (imageDocuments.isEmpty) {
        _lastSnapshot = null;
        status = Status.none;
        notifyListeners();
        return;
      }
      _images.addAll(imageDocuments);
      imagesSink.add(_images);
      _lastSnapshot = imageDocuments.last;
      status = AlbumStatus.fetchImagesSuccess;
      debugPrint('追加読み込み, ${_images.length}');
    } on NoSelectScheduleException {
      imagesSink.addError(NoSelectScheduleException());
      status = Status.none;
    }
    notifyListeners();
  }

  Future<void> checkSelectedSchedule() async {
    try {
      final user =
          await fromCancelable(_userRepositoryImpl.fetchUser()) as UserEntity;
      isSelectedSchedule = user.selectScheduleId.isNotEmpty;
    } on UnLoginException {
      isSelectedSchedule = false;
    } on UserDocumentNotExistException {
      isSelectedSchedule = false;
    } on TimeoutException {
      isSelectedSchedule = false;
    }
  }
}
