import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/custom_exceptions.dart';
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

  Future<bool> _isSelectedSchedule() async {
    final user = await _userRepositoryImpl.fetchUser();
    return user.selectScheduleId.isNotEmpty;
  }

  Future<void> uploadSelectImages() async {
    try {
      if(!await _isSelectedSchedule()) {
        debugPrint('スケジュールが選択されていません。');
        return;
      }
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
      List<String> urls = List<String>();
      for (final images in pickUpImages) {
        final uploadUrl = await _imageRepositoryImpl.uploadImage(images);
        urls.add(uploadUrl);
      }
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