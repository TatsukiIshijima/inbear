import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:inbear_app/repository/user_repository.dart';

class LoginViewModel extends ChangeNotifier {

  final UserRepository userRepository;
  final TextEditingController emailTextEditingController = TextEditingController();
  final TextEditingController passwordTextEditingController = TextEditingController();

  LoginViewModel({
    @required
    this.userRepository,
  });

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    try {
      await userRepository.signIn(
          emailTextEditingController.text,
          passwordTextEditingController.text
      );
    } catch (error) {
      print(error);
    }
  }
}