import 'package:multi_image_picker/multi_image_picker.dart';

abstract class ImageDataSourceImpl {
  Future<Map<String, String>> uploadImage(String documentId, Asset asset);

  Future<void> downloadImage();

  Future<void> deleteImage(String imageUrl);
}
