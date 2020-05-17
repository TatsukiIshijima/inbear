class UnLoginException implements Exception {
  UnLoginException();
}

class DocumentNotExistException implements Exception {
  DocumentNotExistException();
}

class UserDocumentNotExistException extends DocumentNotExistException {
  UserDocumentNotExistException();
}

class ScheduleDocumentNotExistException extends DocumentNotExistException {
  ScheduleDocumentNotExistException();
}

class NoSelectScheduleException implements Exception {
  NoSelectScheduleException();
}

class UploadImageException implements Exception {
  UploadImageException();
}

class NotRegisterAnyImagesException implements Exception {
  NotRegisterAnyImagesException();
}
