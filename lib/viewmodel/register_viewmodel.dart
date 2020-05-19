import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/status.dart';

class RegisterViewModel extends ChangeNotifier {
  final UserRepositoryImpl _userRepository;
  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();

  String authStatus = Status.none;

  RegisterViewModel(this._userRepository);

  Future<void> signUp() async {
    try {
      authStatus = Status.loading;
      notifyListeners();
      debugPrint(
          '${nameTextEditingController.text}, ${emailTextEditingController.text} sign up...');
      await _userRepository.signUp(nameTextEditingController.text,
          emailTextEditingController.text, passwordTextEditingController.text);
      authStatus = Status.success;
    } on WeakPasswordException {
      authStatus = AuthStatus.weakPasswordError;
    } on InvalidEmailException {
      authStatus = AuthStatus.invalidEmailError;
    } on EmailAlreadyInUseException {
      authStatus = AuthStatus.emailAlreadyUsedError;
    } on InvalidCredentialException {
      authStatus = AuthStatus.invalidCredentialError;
    } on TooManyRequestException {
      authStatus = AuthStatus.tooManyRequestsError;
    } on NetworkRequestException {
      authStatus = Status.networkError;
    } on TimeoutException {
      authStatus = Status.timeoutError;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    nameTextEditingController.dispose();
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.dispose();
  }
}
