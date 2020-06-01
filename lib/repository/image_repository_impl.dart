import 'package:multi_image_picker/multi_image_picker.dart';

abstract class ImageRepositoryImpl {
  Future<Map<String, String>> uploadImage(String documentId, Asset asset);
  Future<void> deleteImage(String imageUrl);
}
