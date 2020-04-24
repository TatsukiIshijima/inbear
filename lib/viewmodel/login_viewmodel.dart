import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:inbear_app/repository/user_repository.dart';

import '../auth_status.dart';

class LoginViewModel extends ChangeNotifier {

  final UserRepository _userRepository;
  final TextEditingController emailTextEditingController = TextEditingController();
  final TextEditingController passwordTextEditingController = TextEditingController();

  AuthStatus authStatus;

  LoginViewModel(
    this._userRepository,
  );

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    authStatus = AuthStatus.Authenticating;
    notifyListeners();

    var result = await _userRepository.signIn(
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
}