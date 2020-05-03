import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inbear_app/model/user.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';

class UserRepository implements UserRepositoryImpl {

  final FirebaseAuth _auth;
  final Firestore _db;
  final String _userCollection = 'user';

  UserRepository(
    this._auth,
    this._db
  );

  @override
  Future<String> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return '';
    } catch (error) {
      return error.code;
    }
  }

  @override
  Future<String> signUp(String name, String email, String password) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      var user = User(
        result.user.uid,
        name,
        email,
        DateTime.now()
      );
      _db.collection(_userCollection)
        .document(result.user.uid)
        .setData(user.toMap());
      return '';
    } catch (error) {
      return error.code;
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<bool> isSignIn() async {
    var currentUser = (await _auth.currentUser());
    return currentUser != null;
  }

  @override
  Future<String> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return '';
    } catch (error) {
      return error.code;
    }
  }
}