import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/status.dart';
import 'package:inbear_app/viewmodel/base_viewmodel.dart';

class UserRegisterViewModel extends BaseViewModel {
  final UserRepositoryImpl _userRepository;
  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();

  UserRegisterViewModel(this._userRepository);

  Future<void> executeSignUp() async {
    await executeFutureOperation(() => _signUp());
  }

  Future<void> _signUp() async {
    try {
      await fromCancelable(_userRepository.signUp(
          nameTextEditingController.text,
          emailTextEditingController.text,
          passwordTextEditingController.text));
      status = Status.success;
    } on WeakPasswordException {
      status = AuthStatus.weakPasswordError;
    } on InvalidEmailException {
      status = AuthStatus.invalidEmailError;
    } on EmailAlreadyInUseException {
      status = AuthStatus.emailAlreadyUsedError;
    } on InvalidCredentialException {
      status = AuthStatus.invalidCredentialError;
    } on TooManyRequestException {
      status = AuthStatus.tooManyRequestsError;
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
