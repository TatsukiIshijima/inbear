class TooManyRequestException implements Exception {}

class NetworkRequestException implements Exception {}

class DocumentNotExistException implements Exception {}

class UserDocumentNotExistException extends DocumentNotExistException {}

class ScheduleDocumentNotExistException extends DocumentNotExistException {}

class NoSelectScheduleException implements Exception {}

class UploadImageException implements Exception {}

class NotRegisterAnyImagesException implements Exception {}

class ParticipantsEmptyException implements Exception {}

class SearchUsersEmptyException implements Exception {}
