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
  Future<void> signUp(String name, String email, String password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      var user = User(
        uid: result.user.uid,
        name: name
      );
      _db.collection(_userCollection)
        .document(result.user.uid)
        .setData(user.toMap());
    } catch (error) {
      Future.error(error.code);
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<String> isSignIn() async {
    var currentUser = (await _auth.currentUser());
    return currentUser != null ? currentUser.uid : '';
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}