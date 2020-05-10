import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class AlbumViewModel extends ChangeNotifier {

  void uploadImage() {
    debugPrint('uploadImage');
  }

  Future<void> loadImages() async {
    try {
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
    } on Exception catch(e) {
      debugPrint(e.toString());
    }
  }
}