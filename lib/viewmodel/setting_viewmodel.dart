import 'package:flutter/material.dart';
import 'package:inbear_app/repository/user_repository.dart';

class SettingViewModel extends ChangeNotifier {
  final UserRepository _userRepository;

  SettingViewModel(this._userRepository);

  Future<void> signOut() async {
    await _userRepository.signOut();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
