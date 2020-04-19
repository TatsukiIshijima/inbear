import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:inbear_app/model/user.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';

class UserRepository implements UserRepositoryImpl {

  final FirebaseAuth auth;
  final Firestore db;
  final String _userCollection = 'user';

  UserRepository({
    @required
    this.auth,
    @required
    this.db
  });

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } catch (error) {
      Future.error(error.code);
    }
  }

  @override
  Future<void> signUp(String name, String email, String password) async {
    try {
      var result = await auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      var user = User(
        uid: result.user.uid,
        name: name
      );
      db.collection(_userCollection)
        .document(result.user.uid)
        .setData(user.toMap());
    } catch (error) {
      Future.error(error.code);
    }
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }

  @override
  Future<String> isSignIn() async {
    var currentUser = (await auth.currentUser());
    return currentUser != null ? currentUser.uid : '';
  }
}