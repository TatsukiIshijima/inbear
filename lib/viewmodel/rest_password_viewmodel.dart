import 'package:flutter/material.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/status.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  final UserRepositoryImpl _userRepository;

  ResetPasswordViewModel(this._userRepository);

  final TextEditingController emailTextEditingController =
      TextEditingController();

  String authStatus;

  Future<void> sendPasswordResetEmail() async {
    try {
      authStatus = Status.loading;
      notifyListeners();
      await _userRepository
          .sendPasswordResetEmail(emailTextEditingController.text);
      authStatus = Status.success;
    } catch (error) {
      final errorCode = error.code.toString();
      switch (errorCode) {
        case 'ERROR_INVALID_EMAIL':
          authStatus = AuthStatus.invalidEmailError;
          break;
        case 'ERROR_USER_NOT_FOUND':
          authStatus = AuthStatus.userNotFoundError;
          break;
        default:
          authStatus = AuthStatus.unDefinedError;
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
