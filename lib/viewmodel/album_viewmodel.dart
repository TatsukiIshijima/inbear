import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/entity/image_entity.dart';
import 'package:inbear_app/repository/image_repository_impl.dart';
import 'package:inbear_app/repository/schedule_repository_impl.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../status.dart';

class AlbumStatus extends Status {
  static const userDataNotExistError = 'USER_DATA_NOT_EXIST_ERROR';
  static const noSelectScheduleError = 'NO_SELECT_SCHEDULE_ERROR';
  static const permissionDeniedError = 'PERMISSION_DENIED_ERROR';
  static const permissionPermanentlyDeniedError =
      'PERMISSION_PERMANENTLY_DENIED_ERROR';
  static const imageUploadError = 'IMAGE_UPLOAD_ERROR';
}

class AlbumViewModel extends ChangeNotifier {
  final UserRepositoryImpl _userRepositoryImpl;
  final ScheduleRepositoryImpl _scheduleRepositoryImpl;
  final ImageRepositoryImpl _imageRepositoryImpl;

  AlbumViewModel(this._userRepositoryImpl, this._scheduleRepositoryImpl,
      this._imageRepositoryImpl);

  static const _imageUrlKey = 'image_url';
  static const _thumbnailUrlKey = 'thumbnail_url';

  final _imagesStreamController = StreamController<List<ImageEntity>>();
  final List<ImageEntity> _images = <ImageEntity>[];
  final scrollController = ScrollController();

  Stream<List<ImageEntity>> get imagesStream => _imagesStreamController.stream;
  StreamSink<List<ImageEntity>> get imagesSink => _imagesStreamController.sink;

  String status = Status.none;
  DocumentSnapshot _lastSnapshot;
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
        await fetchImagesNext();
        _isLoading = false;
      }
    });
  }

  Future<void> uploadSelectImages() async {
    try {
      status = Status.loading;
      notifyListeners();
      final user = await _userRepositoryImpl.fetchUser();
      if (user.selectScheduleId.isEmpty) {
        throw NoSelectScheduleException();
      }
      var pickUpImages = await MultiImagePicker.pickImages(
          maxImages: 5,
          enableCamera: false,
          materialOptions: MaterialOptions(
            statusBarColor: '#bf5f82',
            actionBarColor: '#f48fb1',
            actionBarTitleColor: '#ffffff',
            actionBarTitle: '写真',
          ));
      if (pickUpImages.isEmpty) {
        status = Status.none;
        notifyListeners();
        return;
      }
      final imageEntities = <ImageEntity>[];
      for (final image in pickUpImages) {
        final uploadUrls = await _imageRepositoryImpl.uploadImage(image);
        final imageEntity = ImageEntity(uploadUrls[_imageUrlKey],
            uploadUrls[_thumbnailUrlKey], user.uid, DateTime.now());
        imageEntities.add(imageEntity);
      }
      await _scheduleRepositoryImpl.postImages(
          user.selectScheduleId, imageEntities);
      await fetchImageAtStart();
      status = Status.success;
    } on UnLoginException {
      status = Status.unLoginError;
    } on UserDocumentNotExistException {
      status = AlbumStatus.userDataNotExistError;
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

  Future<void> fetchImageAtStart() async {
    try {
      _images.clear();
      final selectScheduleId =
          (await _userRepositoryImpl.fetchUser()).selectScheduleId;
      if (selectScheduleId.isEmpty) {
        throw NoSelectScheduleException();
      }
      final imageDocuments =
          await _scheduleRepositoryImpl.fetchImagesAtStart(selectScheduleId);
      if (imageDocuments.isEmpty) {
        throw NotRegisterAnyImagesException();
      }
      final imageEntities =
          imageDocuments.map((doc) => ImageEntity.fromMap(doc.data)).toList();
      _images.addAll(imageEntities);
      if (_imagesStreamController.isClosed) {
        // 画面を閉じた時などでクローズされているままStreamに追加されないようにする
        debugPrint('fetchImagesAtStart : imageStreamController is closed.');
        return;
      }
      imagesSink.add(_images);
      _lastSnapshot = imageDocuments.last;
    } on UnLoginException {
      imagesSink.addError(UnLoginException());
    } on UserDocumentNotExistException {
      imagesSink.addError(UserDocumentNotExistException());
    } on NoSelectScheduleException {
      imagesSink.addError(NoSelectScheduleException());
    } on NotRegisterAnyImagesException {
      imagesSink.addError(NotRegisterAnyImagesException());
    } on TimeoutException {
      imagesSink.addError(TimeoutException('fetch image at start time out.'));
    }
  }

  Future<void> fetchImagesNext() async {
    try {
      final selectScheduleId =
          (await _userRepositoryImpl.fetchUser()).selectScheduleId;
      if (selectScheduleId.isEmpty) {
        throw NoSelectScheduleException();
      }
      if (_lastSnapshot == null) {
        return;
      }
      final imageDocuments = await _scheduleRepositoryImpl.fetchImagesNext(
          selectScheduleId, _lastSnapshot);
      if (imageDocuments.isEmpty) {
        _lastSnapshot = null;
        return;
      }
      final imageEntities =
          imageDocuments.map((doc) => ImageEntity.fromMap(doc.data)).toList();
      _images.addAll(imageEntities);
      // 画面を閉じた時などでクローズされているままStreamに追加されないようにする
      if (_imagesStreamController.isClosed) {
        debugPrint('fetchImagesNext : imageStreamController is closed.');
        return;
      }
      imagesSink.add(_images);
      _lastSnapshot = imageDocuments.last;
      debugPrint('追加読み込み, ${_images.length}');
    } on UnLoginException {
      imagesSink.addError(UnLoginException());
    } on UserDocumentNotExistException {
      imagesSink.addError(UserDocumentNotExistException());
    } on NoSelectScheduleException {
      imagesSink.addError(NoSelectScheduleException());
    }
  }
}
