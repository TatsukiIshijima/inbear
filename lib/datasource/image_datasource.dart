import 'package:firebase_storage/firebase_storage.dart';
import 'package:inbear_app/datasource/image_datasource_impl.dart';
import 'package:inbear_app/exception/storage/firebase_storage_exception.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uuid/uuid.dart';

class ImageDataSource implements ImageDataSourceImpl {
  final FirebaseStorage _storage;

  ImageDataSource(this._storage);

  static const _originalDefaultWidth = 720;
  static const _originalDefaultHeight = 1280;
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
    final originalReference =
        _storage.ref().child('$documentId/original/$uuid.jpg');
    final thumbnailReference =
        _storage.ref().child('$documentId/thumbnail/$uuid-thumb.jpg');

    var originalWidth = _originalDefaultWidth;
    var originalHeight = _originalDefaultHeight;
    var thumbnailWidth = _thumbnailDefaultWidth;
    var thumbnailHeight = _thumbnailDefaultHeight;

    if (asset.originalWidth >= asset.originalHeight) {
      originalWidth = _originalDefaultHeight;
      originalHeight = _originalDefaultWidth;
      thumbnailWidth = _thumbnailDefaultHeight;
      thumbnailHeight = _thumbnailDefaultWidth;
    }

    // FIXME:ここはwaitが使えない!?
    final originalByteData =
        await asset.getThumbByteData(originalWidth, originalHeight);
    final thumbnailByteData =
        await asset.getThumbByteData(thumbnailWidth, thumbnailHeight);

    final originalData = originalByteData.buffer.asUint8List();
    final thumbnailData = thumbnailByteData.buffer.asUint8List();

    final originalUploadTask =
        originalReference.putData(originalData, metadata);
    final thumbnailUploadTask =
        thumbnailReference.putData(thumbnailData, metadata);

    final uploadTasks = Future.wait(
        [originalUploadTask.onComplete, thumbnailUploadTask.onComplete]);
    final uploadTaskResults = await uploadTasks;

    if (uploadTaskResults[0].error != null) {
      throw UploadImageException(uploadTaskResults[0].error);
    }
    if (uploadTaskResults[1].error != null) {
      throw UploadImageException(uploadTaskResults[1].error);
    }

    final getOriginalUrlTask = uploadTaskResults[0].ref.getDownloadURL();
    final getThumbnailUrlTask = uploadTaskResults[1].ref.getDownloadURL();

    final getUrlTasks =
        Future.wait<dynamic>([getOriginalUrlTask, getThumbnailUrlTask]);
    final getUrlTaskResults = await getUrlTasks;

    return {
      _originalUrlKey: getUrlTaskResults[0] as String,
      _thumbnailUrlKey: getUrlTaskResults[1] as String
    };
  }

  @override
  Future<void> deleteImage(String imageUrl) async {
    final storageRef = await _storage.getReferenceFromUrl(imageUrl);
    await storageRef.delete();
  }
}
