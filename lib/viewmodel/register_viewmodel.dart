import 'package:flutter/widgets.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/status.dart';

class RegisterViewModel extends ChangeNotifier {
  final UserRepositoryImpl _userRepository;
  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();

  String authStatus = Status.none;

  RegisterViewModel(this._userRepository);

  Future<void> signUp() async {
    try {
      authStatus = Status.loading;
      notifyListeners();
      await _userRepository.signUp(nameTextEditingController.text,
          emailTextEditingController.text, passwordTextEditingController.text);
      authStatus = Status.success;
    } catch (error) {
      final errorCode = error.code.toString();
      switch (errorCode) {
        // ここのエラーは変わる可能性があるので、直接記述
        case 'ERROR_WEAK_PASSWORD':
          authStatus = AuthStatus.weakPasswordError;
          break;
        case 'ERROR_INVALID_EMAIL':
          authStatus = AuthStatus.invalidEmailError;
          break;
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          authStatus = AuthStatus.emailAlreadyUsedError;
          break;
        case 'ERROR_INVALID_CREDENTIAL':
          authStatus = AuthStatus.invalidCredentialError;
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          authStatus = AuthStatus.tooManyRequestsError;
          break;
        default:
          authStatus = AuthStatus.unDefinedError;
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
