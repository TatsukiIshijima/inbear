import 'package:flutter/widgets.dart';
import 'package:inbear_app/localize/app_localizations.dart';

enum AuthStatus {
  Success,
  Authenticating,
  ErrorInvalidEmail,
  ErrorWrongPassword,
  ErrorUserNotFound,
  ErrorUserDisabled,
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
      case AuthStatus.ErrorWrongPassword:
        return resource.wrongPasswordError;
      case AuthStatus.ErrorUserNotFound:
        return resource.userNotFoundError;
      case AuthStatus.ErrorUserDisabled:
        return resource.userDisabledError;
      case AuthStatus.ErrorTooManyRequests:
        return resource.tooManyRequestsError;
      default:
        return resource.generalError;
    }
  }
}