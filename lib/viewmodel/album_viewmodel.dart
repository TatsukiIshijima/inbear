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

  AlbumViewModel(
    this._userRepositoryImpl,
    this._scheduleRepositoryImpl,
    this._imageRepositoryImpl
  );

  static const _imageUrlKey = 'image_url';
  static const _thumbnailUrlKey = 'thumbnail_url';

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
        )
      );
      if (pickUpImages.length == 0) {
        return;
      }
      List<ImageEntity> imageEntities = List<ImageEntity>();
      for (final image in pickUpImages) {
        final uploadUrls = await _imageRepositoryImpl.uploadImage(image);
        final ImageEntity imageEntity = ImageEntity(
          uploadUrls[_imageUrlKey],
          uploadUrls[_thumbnailUrlKey],
          user.uid,
          DateTime.now()
        );
        imageEntities.add(imageEntity);
      }
      await _scheduleRepositoryImpl.postImages(user.selectScheduleId, imageEntities);
    } on UnLoginException {
      debugPrint('ログインしていない');
    } on DocumentNotExistException {
      debugPrint('ユーザードキュメントが存在しない');
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
}