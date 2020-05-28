import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/viewmodel/base_viewmodel.dart';

class SettingViewModel extends BaseViewModel {
  final UserRepository _userRepository;

  SettingViewModel(this._userRepository);

  Future<void> signOut() async {
    await _userRepository.signOut();
  }
}
