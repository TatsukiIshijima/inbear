import 'package:flutter/foundation.dart';
import 'package:inbear_app/repository/user_repository.dart';

class LoginViewModel extends ChangeNotifier {

  final UserRepository userRepository;

  LoginViewModel({
    @required
    this.userRepository,
  });

  void sample() {
    print('LoginViewModel sample called.');
  }

  @override
  void dispose() {
    super.dispose();
  }
}