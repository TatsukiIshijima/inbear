import 'package:flutter/widgets.dart';
import 'package:inbear_app/localize/app_localizations.dart';

enum AuthStatus {
  Success,
  Authenticating,
  ErrorInvalidEmail,
  ErrorEmailAlreadyUsed,
  ErrorWrongPassword,
  ErrorWeakPassword,
  ErrorUserNotFound,
  ErrorUserDisabled,
  ErrorInvalidCredential,
  ErrorTooManyRequests,
  ErrorUnDefined,
}

extension AuthStatusExtension on AuthStatus {
  static String toMessage(BuildContext context, AuthStatus authStatus) {
    var resource = AppLocalizations.of(context);
    switch(authStatus) {
      case AuthStatus.Success:
        return '';
      case AuthStatus.Authenticating:
        return '';
      case AuthStatus.ErrorInvalidEmail:
        return resource.invalidEmailError;
      case AuthStatus.ErrorEmailAlreadyUsed:
        return resource.alreadyUsedEmailError;
      case AuthStatus.ErrorWrongPassword:
        return resource.wrongPasswordError;
      case AuthStatus.ErrorWeakPassword:
        return resource.weakPasswordError;
      case AuthStatus.ErrorUserNotFound:
        return resource.userNotFoundError;
      case AuthStatus.ErrorUserDisabled:
        return resource.userDisabledError;
      case AuthStatus.ErrorInvalidCredential:
        return resource.invalidCredentialError;
      case AuthStatus.ErrorTooManyRequests:
        return resource.tooManyRequestsError;
      default:
        return resource.generalError;
    }
  }
}