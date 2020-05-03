import 'package:inbear_app/model/user.dart';

class UserRepositoryImpl {
  Future<String> signIn(String email, String password) {}
  Future<String> signUp(String name, String email, String password) {}
  Future<void> signOut() {}
  Future<bool> isSignIn() {}
  Future<String> sendPasswordResetEmail(String email) {}
  Future<String> getUid() {}
  Future<User> fetchUser() {}
  Future<String> addScheduleReference(String scheduleId) {}
}