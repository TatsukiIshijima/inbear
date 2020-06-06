class Status {
  final String _value;
  const Status(this._value);
  @override
  String toString() => 'Status.$_value';

  static const none = Status('NONE');
  static const loading = Status('LOADING');
  static const success = Status('SUCCESS');
  static const unLoginError = Status('UNLOGIN_ERROR');
  static const userDocumentNotExistError =
      Status('USER_DOCUMENT_NOT_EXIST_ERROR');
  static const scheduleDocumentNotExistError =
      Status('SCHEDULE_DOCUMENT_NOT_EXIST_ERROR');
  static const timeoutError = Status('TIME_OUT_ERROR');
  static const httpError = Status('HTTP_ERROR');
  static const badRequestError = Status('BAD_REQUEST_ERROR');
  static const notFoundError = Status('NOT_FOUND_ERROR');
  static const methodNotAllowError = Status('METHOD_NOT_ALLOW_ERROR');
  static const tooManyRequestsError = Status('TOO_MANY_REQUESTS_ERROR');
  static const internalServerError = Status('INTERNAL_SERVER_ERROR');
  static const socketError = Status('SOCKET_ERROR');
  static const networkError = Status('NETWORK_ERROR');
  static const generalError = Status('GENERAL_ERROR');
}

class AuthStatus extends Status {
  AuthStatus(String value) : super(value);
  static const invalidEmailError = Status('INVALID_EMAIL_ERROR');
  static const emailAlreadyUsedError = Status('EMAIL_ALREADY_USED_ERROR');
  static const wrongPasswordError = Status('WRONG_PASSWORD_ERROR');
  static const weakPasswordError = Status('WEAK_PASSWORD_ERROR');
  static const userNotFoundError = Status('USER_NOT_FOUND_ERROR');
  static const userDisabledError = Status('USER_DISABLED_ERROR');
  static const invalidCredentialError = Status('INVALID_CREDENTIAL_ERROR');
}
