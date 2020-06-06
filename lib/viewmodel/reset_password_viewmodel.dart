import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/exception/auth/auth_exception.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/status.dart';
import 'package:inbear_app/viewmodel/base_viewmodel.dart';

class ResetPasswordViewModel extends BaseViewModel {
  final UserRepositoryImpl _userRepository;

  ResetPasswordViewModel(this._userRepository);

  final TextEditingController emailTextEditingController =
      TextEditingController();

  Future<void> executeSendResetPasswordMail() async {
    await executeFutureOperation(() => _sendPasswordResetEmail());
  }

  Future<void> _sendPasswordResetEmail() async {
    try {
      await fromCancelable(_userRepository
          .sendPasswordResetEmail(emailTextEditingController.text));
      status = Status.success;
    } on InvalidEmailException {
      status = AuthStatus.invalidEmailError;
    } on UserNotFoundException {
      status = AuthStatus.userNotFoundError;
    } on UserDisabledException {
      status = AuthStatus.userDisabledError;
    } on TooManyRequestException {
      status = AuthStatus.tooManyRequestsError;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    emailTextEditingController.dispose();
    super.dispose();
  }
}
