import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/datasource/image_datasource_impl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImageDataSource implements ImageDataSourceImpl {

  final FirebaseStorage _storage;

  ImageDataSource(this._storage);

  @override
  Future<void> downloadImage() {
    // TODO: implement downloadImage
    throw UnimplementedError();
  }

  @override
  Future<String> uploadImage(Asset asset) async {
    final ByteData byteData = await asset.getByteData(quality: 50);
    // TODO:ここでサムネイルを作成してアップするか検討
    // https://sh1d0w.github.io/multi_image_picker/#/imagedata
    List<int> imageData = byteData.buffer.asUint8List();
    final StorageReference storageReference = _storage.ref().child('hoge.jpg');
    final StorageUploadTask storageUploadTask =
      storageReference.putData(
        imageData,
        StorageMetadata(
          contentType: 'image/jpeg'
        )
    );
    final StorageTaskSnapshot storageTaskSnapshot = await storageUploadTask.onComplete;
    if ( storageTaskSnapshot.error == null) {
      return await storageTaskSnapshot.ref.getDownloadURL();
    } else {
      throw UploadImageException();
    }
  }

}