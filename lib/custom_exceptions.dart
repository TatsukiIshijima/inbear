class InvalidEmailException implements Exception {}

class WrongPasswordException implements Exception {}

class UserNotFoundException implements Exception {}

class UserDisabledException implements Exception {}

class WeakPasswordException implements Exception {}

class EmailAlreadyInUseException implements Exception {}

class InvalidCredentialException implements Exception {}

class TooManyRequestException implements Exception {}

class NetworkRequestException implements Exception {}

class UnLoginException implements Exception {}

class DocumentNotExistException implements Exception {}

class UserDocumentNotExistException extends DocumentNotExistException {}

class ScheduleDocumentNotExistException extends DocumentNotExistException {}

class NoSelectScheduleException implements Exception {}

class UploadImageException implements Exception {}

class NotRegisterAnyImagesException implements Exception {}
