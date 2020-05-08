import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/entity/user_entity.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';

class UserRepository implements UserRepositoryImpl {

  final FirebaseAuth _auth;
  final Firestore _db;
  final String _userCollection = 'user';
  final String _scheduleSubCollection = 'schedule';

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
      var user = UserEntity(
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
  Future<UserEntity> fetchUser() async {
    var uid = await getUid();
    if (uid.isEmpty) {
      throw UnLoginException();
    }
    var userDocument = await _db.collection(_userCollection)
        .document(uid)
        .get();
    if (!userDocument.exists) {
      throw DocumentNotExistException();
    }
    return UserEntity.fromMap(userDocument.data);
  }

  @override
  Future<void> addScheduleReference(String scheduleId) async {
    var uid = await getUid();
    if (uid.isEmpty) {
      throw UnLoginException();
    }
    var scheduleReference = _db.collection(_scheduleSubCollection)
        .document(scheduleId);
    await _db.collection(_userCollection)
        .document(uid)
        .collection(_scheduleSubCollection)
        .document(scheduleId)
        .setData({'ref': scheduleReference});
  }

  @override
  Future<void> selectSchedule(String scheduleId) async {
    var uid = await getUid();
    if (uid.isEmpty) {
      throw UnLoginException();
    }
    await _db.collection(_userCollection)
        .document(uid)
        .setData({'select_schedule_id': scheduleId}, merge: true);
  }

  @override
  Future<List<ScheduleEntity>> fetchEntrySchedule() async {
    var uid = await getUid();
    if (uid.isEmpty) {
      throw UnLoginException();
    }
    var schedules = List<ScheduleEntity>();
    var documents = (await _db.collection(_userCollection)
        .document(uid)
        .collection(_scheduleSubCollection)
        .getDocuments()).documents;
    for (var doc in documents) {
      // Reference型から直接データ参照できなかったため、
      // 冗長にデータを引っ張ってくる
      var docReference = doc.data['ref'];
      if (docReference is DocumentReference) {
        var scheduleDoc = await docReference.parent()
            .document(docReference.documentID)
            .get();
        schedules.add(ScheduleEntity.fromMap(scheduleDoc.data));
      }
    }
    return schedules;
  }
}