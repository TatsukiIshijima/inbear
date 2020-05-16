import 'package:firebase_storage/firebase_storage.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/datasource/image_datasource_impl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uuid/uuid.dart';

class ImageDataSource implements ImageDataSourceImpl {
  final FirebaseStorage _storage;

  ImageDataSource(this._storage);

  static const _originalImageQuality = 50;
  static const _thumbnailImageQuality = 30;
  static const _thumbnailImageRate = 0.2;

  static const _imageUrlKey = 'image_url';
  static const _thumbnailUrlKey = 'thumbnail_url';

  @override
  Future<void> downloadImage() {
    // TODO: implement downloadImage
    throw UnimplementedError();
  }

  @override
  Future<Map<String, String>> uploadImage(Asset asset) async {
    final byteData = await asset.getByteData(quality: _originalImageQuality);
    final thumbnailByteData = await asset.getThumbByteData(
        (asset.originalWidth * _thumbnailImageRate).round(),
        (asset.originalHeight * _thumbnailImageRate).round(),
        quality: _thumbnailImageQuality);
    final uuid = Uuid();
    final imageData = byteData.buffer.asUint8List();
    final thumbnailData = thumbnailByteData.buffer.asUint8List();
    final imageReference = _storage.ref().child('${uuid.v4()}.jpg');
    final thumbnailReference = _storage.ref().child('${uuid.v4()}-thumb.jpg');
    final metadata = StorageMetadata(contentType: 'image/jpeg');
    final imageUploadTask = imageReference.putData(imageData, metadata);
    final thumbnailUploadTask =
        thumbnailReference.putData(thumbnailData, metadata);
    final imageUploadTaskSnapshot = await imageUploadTask.onComplete;
    final thumbnailUploadTaskSnapshot = await thumbnailUploadTask.onComplete;
    if (imageUploadTaskSnapshot.error == null &&
        thumbnailUploadTaskSnapshot.error == null) {
      final imageUrl =
          await imageUploadTaskSnapshot.ref.getDownloadURL() as String;
      final thumbnailUrl =
          await thumbnailUploadTaskSnapshot.ref.getDownloadURL() as String;
      return {_imageUrlKey: imageUrl, _thumbnailUrlKey: thumbnailUrl};
    } else {
      throw UploadImageException();
    }
  }
}
