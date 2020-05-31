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

  static const _originalUrlKey = 'original_url';
  static const _thumbnailUrlKey = 'thumbnail_url';

  @override
  Future<void> downloadImage() {
    // TODO: implement downloadImage
    throw UnimplementedError();
  }

  @override
  Future<Map<String, String>> uploadImage(
      String documentId, Asset asset) async {
    final uuid = Uuid().v4();
    final metadata = StorageMetadata(contentType: 'image/jpeg');
    final originalByteData =
        await asset.getByteData(quality: _originalImageQuality);
    final originalData = originalByteData.buffer.asUint8List();
    final originalReference =
        _storage.ref().child('$documentId/original/$uuid.jpg');
    final thumbnailByteData = await asset.getThumbByteData(
        (asset.originalWidth * _thumbnailImageRate).round(),
        (asset.originalHeight * _thumbnailImageRate).round(),
        quality: _thumbnailImageQuality);
    final thumbnailData = thumbnailByteData.buffer.asUint8List();
    final thumbnailReference =
        _storage.ref().child('$documentId/thumbnail/$uuid-thumb.jpg');
    final originalUploadTask =
        originalReference.putData(originalData, metadata);
    final thumbnailUploadTask =
        thumbnailReference.putData(thumbnailData, metadata);
    final originalUploadTaskSnapshot = await originalUploadTask.onComplete;
    final thumbnailUploadTaskSnapshot = await thumbnailUploadTask.onComplete;
    if (originalUploadTaskSnapshot.error == null &&
        thumbnailUploadTaskSnapshot.error == null) {
      final originalUrl =
          await originalUploadTaskSnapshot.ref.getDownloadURL() as String;
      final thumbnailUrl =
          await thumbnailUploadTaskSnapshot.ref.getDownloadURL() as String;
      return {_originalUrlKey: originalUrl, _thumbnailUrlKey: thumbnailUrl};
    } else {
      throw UploadImageException();
    }
  }
}
