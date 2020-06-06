class FirebaseStorageException implements Exception {}

class UploadImageException implements FirebaseStorageException {
  final int code;

  UploadImageException(this.code);
}
