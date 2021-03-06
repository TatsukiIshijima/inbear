import 'package:inbear_app/datasource/image_datasource_impl.dart';
import 'package:inbear_app/repository/image_repository_impl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImageRepository implements ImageRepositoryImpl {
  final ImageDataSourceImpl _imageDataSourceImpl;

  ImageRepository(
    this._imageDataSourceImpl,
  );

  @override
  Future<Map<String, String>> uploadImage(
      String documentId, Asset asset) async {
    return await _imageDataSourceImpl.uploadImage(documentId, asset);
  }

  @override
  Future<void> deleteImage(String imageUrl) async {
    await _imageDataSourceImpl.deleteImage(imageUrl);
  }
}
