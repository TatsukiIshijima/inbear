import 'package:firebase_storage/firebase_storage.dart';
import 'package:inbear_app/datasource/image_datasource_impl.dart';
import 'package:inbear_app/exception/storage/firebase_storage_exception.dart';
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
    var originalUrl = '';
    if (originalUploadTaskSnapshot.error == null) {
      originalUrl =
          await originalUploadTaskSnapshot.ref.getDownloadURL() as String;
    } else {
      throw UploadImageException(originalUploadTaskSnapshot.error);
    }
    var thumbnailUrl = '';
    final thumbnailUploadTaskSnapshot = await thumbnailUploadTask.onComplete;
    if (thumbnailUploadTaskSnapshot.error == null) {
      thumbnailUrl =
          await thumbnailUploadTaskSnapshot.ref.getDownloadURL() as String;
    } else {
      await deleteImage(originalUrl);
      throw UploadImageException(thumbnailUploadTaskSnapshot.error);
    }
    return {_originalUrlKey: originalUrl, _thumbnailUrlKey: thumbnailUrl};
  }

  @override
  Future<void> deleteImage(String imageUrl) async {
    final storageRef = await _storage.getReferenceFromUrl(imageUrl);
    await storageRef.delete();
  }
}
