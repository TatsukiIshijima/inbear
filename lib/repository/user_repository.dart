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
        '',
        DateTime.now()
      );
      await _db.collection(_userCollection)
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

  @override
  Future<String> getUid() async {
    var user = await _auth.currentUser();
    return user != null ? user.uid : '';
  }

  @override
  Future<User> fetchUser() async {
    try {
      var uid = await getUid();
      if (uid.isEmpty) {
        return null;
      }
      var userData = await _db.collection(_userCollection)
          .document(uid)
          .get();
      return User.fromMap(userData.data);
    } catch (exception) {
      print('Fetch user error : $exception');
      return null;
    }
  }

  @override
  Future<String> addScheduleReference(String scheduleId) async {
    try {
      var uid = await getUid();
      if (uid.isEmpty) {
        return 'User not login.';
      }
      const String _scheduleCollection = 'schedule';
      var scheduleReference = _db.collection(_scheduleCollection)
          .document(scheduleId);
      await _db.collection(_userCollection)
          .document(uid)
          .collection(_scheduleCollection)
          .document(scheduleId)
          .setData({
            'ref': scheduleReference
          });
      return '';
    } catch (exception) {
      print('Add schedule error : $exception');
      return exception;
    }
  }

  @override
  Future<String> selectSchedule(String scheduleId) async {
    try {
      var uid = await getUid();
      if (uid.isEmpty) {
        return 'User not login';
      }
      await _db.collection(_userCollection)
          .document(uid)
          .setData({
            'select_schedule_id': scheduleId
          }, merge: true);
      return '';
    } catch (exception) {
      print('Failed select schedule : $exception');
      return exception;
    }
  }
}