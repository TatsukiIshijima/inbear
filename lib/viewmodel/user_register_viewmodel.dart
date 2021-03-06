import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:inbear_app/exception/auth/auth_exception.dart';
import 'package:inbear_app/exception/common_exception.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/status.dart';
import 'package:inbear_app/viewmodel/base_viewmodel.dart';

class UserRegisterStatus extends Status {
  UserRegisterStatus(String value) : super(value);

  static const registerSuccess = Status('REGISTER_SUCCESS');
}

class UserRegisterViewModel extends BaseViewModel {
  final UserRepositoryImpl _userRepository;
  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();

  bool isVisiblePassword = false;

  UserRegisterViewModel(this._userRepository);

  Future<void> executeSignUp() async {
    await executeFutureOperation(() => _signUp());
  }

  Future<void> _signUp() async {
    try {
      final user = (await fromCancelable(
          _userRepository.createUserWithEmailAndPassword(
              emailTextEditingController.text,
              passwordTextEditingController.text))) as FirebaseUser;
      await fromCancelable(
          _userRepository.insertNewUser(user, nameTextEditingController.text),
          onCancel: () => user.delete());
      await _userRepository.saveEmailAddress(emailTextEditingController.text);
      status = UserRegisterStatus.registerSuccess;
    } on WeakPasswordException {
      status = AuthStatus.weakPasswordError;
    } on InvalidEmailException {
      status = AuthStatus.invalidEmailError;
    } on EmailAlreadyInUseException {
      status = AuthStatus.emailAlreadyUsedError;
    } on InvalidCredentialException {
      status = AuthStatus.invalidCredentialError;
    } on TooManyRequestException {
      status = Status.tooManyRequestsError;
    }
    notifyListeners();
  }

  void changeVisible() {
    isVisiblePassword = !isVisiblePassword;
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
