import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/status.dart';

class LoginViewModel extends ChangeNotifier {

  final UserRepositoryImpl _userRepository;
  final TextEditingController emailTextEditingController = TextEditingController();
  final TextEditingController passwordTextEditingController = TextEditingController();

  String authStatus = Status.none;

  LoginViewModel(
    this._userRepository,
  );

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    try {
      authStatus = Status.loading;
      notifyListeners();
      await _userRepository.signIn(
          emailTextEditingController.text,
          passwordTextEditingController.text
      );
      authStatus = Status.success;
    } catch (error) {
      switch (error.code) {
        case 'ERROR_INVALID_EMAIL':
          authStatus = AuthStatus.invalidEmailError;
          break;
        case 'ERROR_WRONG_PASSWORD':
          authStatus = AuthStatus.wrongPasswordError;
          break;
        case 'ERROR_USER_NOT_FOUND':
          authStatus = AuthStatus.userNotFoundError;
          break;
        case 'ERROR_USER_DISABLED':
          authStatus = AuthStatus.userDisabledError;
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          authStatus = AuthStatus.tooManyRequestsError;
          break;
        default:
          authStatus = AuthStatus.unDefinedError;
          break;
      }
    }
    notifyListeners();
  }

  // workaround
  // ログイン画面がルートのため、replace でルートが変わらない限り、
  // Dispose されなく、画面遷移のたびに build がはしるため、
  // 画面遷移メソッド（push）が呼ばれる箇所でステータスをリセットしておく。
  // signInメソッドの最後に以下の処理があっても build 前に処理されてしまい、
  // Authenticating → null になってしまう。
  // リセットしないと以前のステータスが残ったままのため、
  // 勝手にアラートが表示されたりなどが起こる
  void resetAuthStatus() {
    authStatus = Status.none;
  }
}