import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inbear_app/datasource/image_datasource_impl.dart';
import 'package:inbear_app/repository/image_repository_impl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImageRepository implements ImageRepositoryImpl {

  final Firestore _db;
  final ImageDataSourceImpl _imageDataSourceImpl;

  ImageRepository(
    this._db,
    this._imageDataSourceImpl,
  );

  @override
  Future<String> uploadImage(Asset asset) async{
    return await _imageDataSourceImpl.uploadImage(asset);
  }

  @override
  Future<void> insertUploadImageUrls(List<String> urls) {
    // TODO: implement insertUploadImageUrls
    throw UnimplementedError();
  }

}