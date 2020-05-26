class Status {
  static const String none = 'NONE';
  static const String loading = 'LOADING';
  static const String success = 'SUCCESS';
  static const String unLoginError = 'UNLOGIN_ERROR';
  static const String userDocumentNotExistError =
      'USER_DOCUMENT_NOT_EXIST_ERROR';
  static const String scheduleDocumentNotExistError =
      'SCHEDULE_DOCUMENT_NOT_EXIST_ERROR';
  static const String timeoutError = 'TIME_OUT_ERROR';
  static const String httpError = 'HTTP_ERROR';
  static const String socketError = 'SOCKET_ERROR';
  static const String networkError = 'NETWORK_ERROR';
  static const String generalError = 'GENERAL_ERROR';
}

class AuthStatus extends Status {
  static const invalidEmailError = 'INVALID_EMAIL_ERROR';
  static const emailAlreadyUsedError = 'EMAIL_ALREADY_USED_ERROR';
  static const wrongPasswordError = 'WRONG_PASSWORD_ERROR';
  static const weakPasswordError = 'WEAK_PASSWORD_ERROR';
  static const userNotFoundError = 'USER_NOT_FOUND_ERROR';
  static const userDisabledError = 'USER_DISABLED_ERROR';
  static const invalidCredentialError = 'INVALID_CREDENTIAL_ERROR';
  static const tooManyRequestsError = 'TOO_MANY_REQUESTS_ERROR';
  static const unDefinedError = 'UN_DEFINED_ERROR';
}
