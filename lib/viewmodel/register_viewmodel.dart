import 'package:flutter/widgets.dart';
import 'package:inbear_app/auth_status.dart';
import 'package:inbear_app/repository/user_repository.dart';

class RegisterViewModel extends ChangeNotifier {

  final UserRepository _userRepository;
  final TextEditingController nameTextEditingController = TextEditingController();
  final TextEditingController emailTextEditingController = TextEditingController();
  final TextEditingController passwordTextEditingController = TextEditingController();

  AuthStatus authStatus;

  RegisterViewModel(
    this._userRepository
  );

  Future<void> signUp() async {
    authStatus = AuthStatus.Authenticating;
    notifyListeners();
    var result = await _userRepository.signUp(
        nameTextEditingController.text,
        emailTextEditingController.text,
        passwordTextEditingController.text
    );
    if (result.isEmpty) {
      authStatus = AuthStatus.Success;
    } else {
      switch (result) {
      // ここのエラーは変わる可能性があるので、直接記述
        case "ERROR_WEAK_PASSWORD":
          authStatus = AuthStatus.ErrorWeakPassword;
          break;
        case "ERROR_INVALID_EMAIL":
          authStatus = AuthStatus.ErrorInvalidEmail;
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          authStatus = AuthStatus.ErrorEmailAlreadyUsed;
          break;
        case "ERROR_INVALID_CREDENTIAL":
          authStatus = AuthStatus.ErrorInvalidCredential;
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          authStatus = AuthStatus.ErrorTooManyRequests;
          break;
        default:
          authStatus = AuthStatus.ErrorUnDefined;
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    nameTextEditingController.dispose();
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
  }
}