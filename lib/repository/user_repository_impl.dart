class UserRepositoryImpl {
  Future<String> signIn(String email, String password) {}
  Future<String> signUp(String name, String email, String password) {}
  Future<void> signOut() {}
  Future<String> isSignIn() {}
  Future<String> sendPasswordResetEmail(String email) {}
}