import 'package:flutter/material.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/viewmodel/login_viewmodel.dart';

class ResetPasswordViewModel extends ChangeNotifier {

  final UserRepository _userRepository;

  ResetPasswordViewModel(
    this._userRepository
  );

  TextEditingController emailTextEditingController = TextEditingController();
  AuthStatus authStatus;

  Future<void> sendPasswordResetEmail() async {
    authStatus = AuthStatus.Authenticating;
    notifyListeners();
    var result = await _userRepository.sendPasswordResetEmail(emailTextEditingController.text);
    if (result.isEmpty) {
      authStatus = AuthStatus.Success;
    } else {
      // パスワードリセットメール送信エラーは Auth のエラーと同一のため AuthStatus を使用
      switch (result) {
        case 'ERROR_INVALID_EMAIL':
          authStatus = AuthStatus.ErrorInvalidEmail;
          break;
        case 'ERROR_USER_NOT_FOUND':
          authStatus = AuthStatus.ErrorUserNotFound;
          break;
        default:
          authStatus = AuthStatus.ErrorUnDefined;
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    emailTextEditingController.dispose();
    super.dispose();
  }
}