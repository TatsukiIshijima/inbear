class AuthException implements Exception {}

class UnLoginException implements AuthException {}

class InvalidEmailException implements AuthException {}

class WrongPasswordException implements AuthException {}

class UserNotFoundException implements AuthException {}

class UserDisabledException implements AuthException {}

class WeakPasswordException implements AuthException {}

class EmailAlreadyInUseException implements AuthException {}

class InvalidCredentialException implements AuthException {}
