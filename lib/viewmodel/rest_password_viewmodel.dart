import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/status.dart';
import 'package:inbear_app/viewmodel/base_viewmodel.dart';

class ResetPasswordViewModel extends BaseViewModel {
  final UserRepositoryImpl _userRepository;

  ResetPasswordViewModel(this._userRepository);

  final TextEditingController emailTextEditingController =
      TextEditingController();

  String authStatus;

  Future<void> sendPasswordResetEmail() async {
    await fromCancelable(_sendPasswordResetEmail());
  }

  Future<void> _sendPasswordResetEmail() async {
    try {
      authStatus = Status.loading;
      notifyListeners();
      await _userRepository
          .sendPasswordResetEmail(emailTextEditingController.text);
      authStatus = Status.success;
    } on InvalidEmailException {
      authStatus = AuthStatus.invalidEmailError;
    } on UserNotFoundException {
      authStatus = AuthStatus.userNotFoundError;
    } on UserDisabledException {
      authStatus = AuthStatus.userDisabledError;
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
    emailTextEditingController.dispose();
    super.dispose();
  }
}
