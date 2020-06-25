import 'dart:async';

import 'package:inbear_app/exception/auth/auth_exception.dart';
import 'package:inbear_app/exception/database/firestore_exception.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/viewmodel/base_viewmodel.dart';

class SettingViewModel extends BaseViewModel {
  final UserRepository _userRepository;

  SettingViewModel(this._userRepository);

  Future<String> fetchUserEmail() async {
    try {
      final user = await _userRepository.fetchUser();
      return user.email;
    } on UnLoginException {
      return '';
    } on UserDocumentNotExistException {
      return '';
    } on TimeoutException {
      return '';
    }
  }

  Future<void> signOut() async {
    await _userRepository.signOut();
  }
}
