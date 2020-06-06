import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/exception/auth/auth_exception.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/status.dart';
import 'package:inbear_app/viewmodel/base_viewmodel.dart';

class LoginViewModel extends BaseViewModel {
  final UserRepositoryImpl _userRepository;
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();

  bool isVisiblePassword = false;

  LoginViewModel(
    this._userRepository,
  );

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.dispose();
  }

  Future<void> executeSignIn() async {
    await executeFutureOperation(() => _signIn());
  }

  Future<void> _signIn() async {
    try {
      await fromCancelable(_userRepository.signIn(
          emailTextEditingController.text, passwordTextEditingController.text));
      status = Status.success;
    } on InvalidEmailException {
      status = AuthStatus.invalidEmailError;
    } on WrongPasswordException {
      status = AuthStatus.wrongPasswordError;
    } on UserNotFoundException {
      status = AuthStatus.userNotFoundError;
    } on UserDisabledException {
      status = AuthStatus.userDisabledError;
    } on TooManyRequestException {
      status = AuthStatus.tooManyRequestsError;
    }
    notifyListeners();
  }

  // workaround
  // ログイン画面がルートのため、replace でルートが変わらない限り、
  // Dispose されなく、画面遷移のたびに build がはしるため、
  // 画面遷移メソッド（push）が呼ばれる箇所でステータスをリセットしておく。
  // signInメソッドの最後に以下の処理があっても build 前に処理されてしまい、
  // Authenticating → null になってしまう。
  // リセットしないと以前のステータスが残ったままのため、
  // 勝手にアラートが表示されたりなどが起こる
  void resetAuthStatus() {
    status = Status.none;
  }

  void changeVisible() {
    isVisiblePassword = !isVisiblePassword;
    notifyListeners();
  }
}
