import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:inbear_app/datasource/image_datasource_impl.dart';
import 'package:inbear_app/exception/storage/firebase_storage_exception.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uuid/uuid.dart';

class ImageDataSource implements ImageDataSourceImpl {
  final FirebaseStorage _storage;

  ImageDataSource(this._storage);

  static const _originalImageQuality = 75;
  static const _originalDefaultWidth = 720;
  static const _originalDefaultHeight = 1280;
  static const _thumbnailImageQuality = 75;
  static const _thumbnailDefaultWidth = 270;
  static const _thumbnailDefaultHeight = 480;

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

    ByteData originalByteData;
    ByteData thumbnailByteData;

    if (asset.originalWidth >= asset.originalHeight) {
      originalByteData = await asset.getThumbByteData(
          _originalDefaultHeight, _originalDefaultWidth,
          quality: _originalImageQuality);
      thumbnailByteData = await asset.getThumbByteData(
          _thumbnailDefaultHeight, _thumbnailDefaultWidth,
          quality: _thumbnailImageQuality);
    } else {
      originalByteData = await asset.getThumbByteData(
          _originalDefaultWidth, _originalDefaultHeight,
          quality: _originalImageQuality);
      thumbnailByteData = await asset.getThumbByteData(
          _thumbnailDefaultWidth, _thumbnailDefaultHeight,
          quality: _thumbnailImageQuality);
    }

    final originalData = originalByteData.buffer.asUint8List();
    final originalReference =
        _storage.ref().child('$documentId/original/$uuid.jpg');

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
