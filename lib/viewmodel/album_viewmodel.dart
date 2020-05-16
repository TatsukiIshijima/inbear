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

class AlbumViewModel extends ChangeNotifier {
  final UserRepositoryImpl _userRepositoryImpl;
  final ScheduleRepositoryImpl _scheduleRepositoryImpl;
  final ImageRepositoryImpl _imageRepositoryImpl;

  AlbumViewModel(this._userRepositoryImpl, this._scheduleRepositoryImpl,
      this._imageRepositoryImpl);

  static const _imageUrlKey = 'image_url';
  static const _thumbnailUrlKey = 'thumbnail_url';

  final _imagesStreamController = StreamController<List<ImageEntity>>();
  final scrollController = ScrollController();

  Stream<List<ImageEntity>> get imagesStream => _imagesStreamController.stream;
  StreamSink<List<ImageEntity>> get imagesSink => _imagesStreamController.sink;

  List<ImageEntity> _images = List<ImageEntity>();
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
      final user = await _userRepositoryImpl.fetchUser();
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
    } on UnLoginException {
      debugPrint('ログインしていない');
    } on DocumentNotExistException {
      debugPrint('スケジュールが選択されていない');
    } on NoImagesSelectedException {
      debugPrint('画像の選択のキャンセル');
    } on PermissionDeniedException {
      debugPrint('写真へのアクセス拒否');
    } on PermissionPermanentlyDeniedExeption {
      debugPrint('写真へのアクセルを完全に拒否');
    } on UploadImageException {
      debugPrint('アップロード失敗');
    }
  }

  Future<void> fetchImageAtStart() async {
    try {
      _images.clear();
      final selectScheduleId =
          (await _userRepositoryImpl.fetchUser()).selectScheduleId;
      final imageDocuments =
          await _scheduleRepositoryImpl.fetchImagesAtStart(selectScheduleId);
      if (imageDocuments.isEmpty) {
        return;
      }
      final imageEntities =
          imageDocuments.map((doc) => ImageEntity.fromMap(doc.data)).toList();
      _images.addAll(imageEntities);
      imagesSink.add(_images);
      _lastSnapshot = imageDocuments.last;
    } on UnLoginException {
      imagesSink.addError('ログインしていない');
    } on DocumentNotExistException {
      imagesSink.addError('スケジュールが選択されていない');
    }
  }

  Future<void> fetchImagesNext() async {
    try {
      final selectScheduleId =
          (await _userRepositoryImpl.fetchUser()).selectScheduleId;
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
      imagesSink.add(_images);
      _lastSnapshot = imageDocuments.last;
      debugPrint('追加読み込み, ${_images.length}');
    } on UnLoginException {
      imagesSink.addError('ログインしていない');
    } on DocumentNotExistException {
      imagesSink.addError('スケジュールが選択されていない');
    }
  }
}
