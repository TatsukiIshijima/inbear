import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/entity/user_entity.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';

const invalidEmailError = 'ERROR_INVALID_EMAIL';
const wrongPasswordError = 'ERROR_WRONG_PASSWORD';
const userNotFoundError = 'ERROR_USER_NOT_FOUND';
const userDisabledError = 'ERROR_USER_DISABLED';
const weakPasswordError = 'ERROR_WEAK_PASSWORD';
const emailAlreadyUsedError = 'ERROR_EMAIL_ALREADY_IN_USE';
const invalidCredentialError = 'ERROR_INVALID_CREDENTIAL';
const tooManyRequestsError = 'ERROR_TOO_MANY_REQUESTS';
const networkRequestFailed = 'ERROR_NETWORK_REQUEST_FAILED';

class UserRepository implements UserRepositoryImpl {
  final FirebaseAuth _auth;
  final Firestore _db;
  final String _userCollection = 'user';
  final String _scheduleSubCollection = 'schedule';

  final Map<String, UserEntity> _userCache = {};

  UserRepository(this._auth, this._db);

  void _rethrowAuthException(String errorCode) {
    switch (errorCode) {
      case invalidEmailError:
        throw InvalidEmailException();
        break;
      case wrongPasswordError:
        throw WrongPasswordException();
        break;
      case userNotFoundError:
        throw UserNotFoundException();
        break;
      case userDisabledError:
        throw UserDisabledException();
        break;
      case weakPasswordError:
        throw WeakPasswordException();
        break;
      case invalidCredentialError:
        throw InvalidCredentialException();
        break;
      case tooManyRequestsError:
        throw TooManyRequestException();
        break;
      case networkRequestFailed:
        throw NetworkRequestException();
        break;
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(Duration(seconds: 5),
              onTimeout: () =>
                  throw TimeoutException('UserRepository: signIn Timeout.'));
    } on PlatformException catch (error) {
      debugPrint(
          'UserRepository: signIn Error : ${error.code} ${error.message}');
      _rethrowAuthException(error.code);
    }
  }

  @override
  // ignore: missing_return
  Future<FirebaseUser> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      return (await _auth
              .createUserWithEmailAndPassword(email: email, password: password)
              .timeout(Duration(seconds: 5),
                  onTimeout: () => throw TimeoutException(
                      'UserRepository: createUserWithEmailAndPassword Timeout.')))
          .user;
    } on PlatformException catch (error) {
      debugPrint(
          'UserRepository: createUserWithEmailAndPassword Error: ${error.code}, ${error.message}');
      _rethrowAuthException(error.code);
    }
  }

  @override
  Future<void> insertNewUser(FirebaseUser user, String name) async {
    final userEntity =
        UserEntity(user.uid, name, user.email, '', DateTime.now());
    await _db
        .collection(_userCollection)
        .document(user.uid)
        .setData(userEntity.toMap())
        .timeout(Duration(seconds: 5), onTimeout: () {
      // Firestoreに書き込む時点でユーザーが作成されているので、
      // 再度新規登録しても問題ないようにユーザーを消しておく
      user.delete();
      throw TimeoutException('UserRepository: insertUser Timeout.');
    });
  }

  @override
  Future<void> signOut() async {
    _userCache.clear();
    await _auth.signOut();
  }

  @override
  Future<bool> isSignIn() async {
    // オフライン時でも前にログインしていると User が取得できる
    final currentUser = (await _auth.currentUser());
    return currentUser != null;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email).timeout(
          Duration(seconds: 5),
          onTimeout: () => throw TimeoutException(
              'UserRepository: sendPasswordResetEmail Timeout.'));
    } on PlatformException catch (error) {
      final errorCode = error.code;
      debugPrint('UserRepository: sendPasswordResetEmail Error: $errorCode');
      _rethrowAuthException(errorCode);
    }
  }

  @override
  Future<String> getUid() async {
    var user = await _auth.currentUser();
    return user != null ? user.uid : '';
  }

  @override
  Future<UserEntity> fetchUser() async {
    final uid = await getUid();
    if (uid.isEmpty) {
      throw UnLoginException();
    }
    if (_userCache.containsKey(uid)) {
      return _userCache[uid];
    }
    final userDocument = await _db
        .collection(_userCollection)
        .document(uid)
        .get()
        .timeout(Duration(seconds: 5),
            onTimeout: () =>
                throw TimeoutException('UserRepository: fetchUser Timeout.'));
    if (!userDocument.exists) {
      throw UserDocumentNotExistException();
    }
    _userCache[uid] = UserEntity.fromMap(userDocument.data);
    return _userCache[uid];
  }

  @override
  Future<void> registerSchedule(
      String scheduleId, ScheduleEntity scheduleEntity,
      {bool isUpdate = false}) async {
    final uid = await getUid();
    if (uid.isEmpty) {
      throw UnLoginException();
    }
    await _db
        .collection(_userCollection)
        .document(uid)
        .collection(_scheduleSubCollection)
        .document(scheduleId)
        .setData(scheduleEntity.toMap(), merge: isUpdate)
        .timeout(Duration(seconds: 5),
            onTimeout: () => throw TimeoutException(
                'UserRepository: registerSchedule Timeout.'));
  }

  @override
  Future<void> selectSchedule(String scheduleId) async {
    final uid = await getUid();
    if (uid.isEmpty) {
      throw UnLoginException();
    }
    await _db.collection(_userCollection).document(uid).setData(
        <String, String>{'select_schedule_id': scheduleId},
        merge:
            true).timeout(Duration(seconds: 5),
        onTimeout: () =>
            throw TimeoutException('UserRepository: selectSchedule Timeout.'));
    // キャッシュの User が残ったままだと schedule を切り替えた時に
    // 前の scheduleId を参照してしまうので、キャッシュをクリアする
    _userCache.clear();
  }

  @override
  Future<List<DocumentSnapshot>> fetchEntrySchedule() async {
    final user = await fetchUser();
    return (await _db
            .collection(_userCollection)
            .document(user.uid)
            .collection(_scheduleSubCollection)
            .getDocuments()
            .timeout(Duration(seconds: 5),
                onTimeout: () => throw TimeoutException(
                    'UserRepository: fetchEntrySchedule Timeout.')))
        .documents;
  }

  @override
  Future<List<UserEntity>> searchUser(String email) async {
    final userDocuments = await _db
        .collection(_userCollection)
        .where('email', isEqualTo: email)
        .getDocuments()
        .timeout(Duration(seconds: 5),
            onTimeout: () =>
                throw TimeoutException('UserRepository: searchUser Timeout.'));
    return userDocuments.documents
        .map((doc) => UserEntity.fromMap(doc.data))
        .toList();
  }

  @override
  Future<void> addScheduleInUser(
      String targetUid, String targetScheduleId) async {
    const scheduleCollection = 'schedule';
    final schedule = await _db
        .collection(scheduleCollection)
        .document(targetScheduleId)
        .get()
        .timeout(Duration(seconds: 5),
            onTimeout: () =>
                throw TimeoutException('UserRepository: addSchedule Timeout.'));
    await _db
        .collection(_userCollection)
        .document(targetUid)
        .collection(_scheduleSubCollection)
        .document(targetScheduleId)
        .setData(schedule.data, merge: true)
        .timeout(Duration(seconds: 5),
            onTimeout: () =>
                throw TimeoutException('UserRepository: addSchedule Timeout.'));
  }

  @override
  Future<void> deleteScheduleInUser(
      String targetUid, String targetScheduleId) async {
    await _db
        .collection(_userCollection)
        .document(targetUid)
        .collection(_scheduleSubCollection)
        .document(targetScheduleId)
        .delete()
        .timeout(Duration(seconds: 5),
            onTimeout: () => throw TimeoutException(
                'UserRepository: deleteSchedule Timeout.'));
  }
}
