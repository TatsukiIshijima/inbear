import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/strings.dart';

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

class LoginViewModel extends ChangeNotifier {

  final UserRepository userRepository;
  final TextEditingController emailTextEditingController = TextEditingController();
  final TextEditingController passwordTextEditingController = TextEditingController();

  AuthStatus authStatus;

  LoginViewModel({
    @required
    this.userRepository,
  });

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    authStatus = AuthStatus.Authenticating;
    notifyListeners();

    var result = await userRepository.signIn(
        emailTextEditingController.text,
        passwordTextEditingController.text
    );
    if (result.isEmpty) {
      authStatus = AuthStatus.Success;
    } else {
      switch (result) {
      // ここのエラーは変わる可能性があるので、直接記述
        case 'ERROR_INVALID_EMAIL':
          authStatus = AuthStatus.ErrorInvalidEmail;
          break;
        case 'ERROR_WRONG_PASSWORD':
          authStatus = AuthStatus.ErrorWrongPassword;
          break;
        case 'ERROR_USER_NOT_FOUND':
          authStatus = AuthStatus.ErrorUserNotFound;
          break;
        case 'ERROR_USER_DISABLED':
          authStatus = AuthStatus.ErrorUserDisabled;
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          authStatus = AuthStatus.ErrorTooManyRequests;
          break;
        default:
          authStatus = AuthStatus.ErrorUnDefined;
          break;
      }
    }
    notifyListeners();
  }

  String toLoginErrorMessage() {
    switch(authStatus) {
      case AuthStatus.ErrorInvalidEmail:
        return Strings.InvalidEmailError;
      case AuthStatus.ErrorWrongPassword:
        return Strings.WrongPasswordError;
      case AuthStatus.ErrorUserNotFound:
        return Strings.UserNotFoundError;
      case AuthStatus.ErrorUserDisabled:
        return Strings.UserDisabledError;
      case AuthStatus.ErrorTooManyRequests:
        return Strings.TooManyRequestsError;
      default:
        return Strings.GeneralError;
    }
  }
}