import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/entity/user_entity.dart';
import 'package:inbear_app/model/schedule_select_item_model.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';

class UserRepository implements UserRepositoryImpl {
  final FirebaseAuth _auth;
  final Firestore _db;
  final String _userCollection = 'user';
  final String _scheduleSubCollection = 'schedule';

  Map<String, UserEntity> _userCache = Map();

  UserRepository(this._auth, this._db);

  @override
  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signUp(String name, String email, String password) async {
    var result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    var user = UserEntity(result.user.uid, name, email, '', DateTime.now());
    await _db
        .collection(_userCollection)
        .document(result.user.uid)
        .setData(user.toMap());
  }

  @override
  Future<void> signOut() async {
    _userCache.clear();
    await _auth.signOut();
  }

  @override
  Future<bool> isSignIn() async {
    var currentUser = (await _auth.currentUser());
    return currentUser != null;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
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
    if (_userCache.containsKey(uid)) {
      return _userCache[uid];
    }
    var userDocument =
        await _db.collection(_userCollection).document(uid).get();
    if (!userDocument.exists) {
      throw DocumentNotExistException();
    }
    _userCache[uid] = UserEntity.fromMap(userDocument.data);
    return _userCache[uid];
  }

  @override
  Future<void> addScheduleReference(String scheduleId) async {
    var uid = await getUid();
    if (uid.isEmpty) {
      throw UnLoginException();
    }
    var scheduleReference =
        _db.collection(_scheduleSubCollection).document(scheduleId);
    await _db
        .collection(_userCollection)
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
    await _db
        .collection(_userCollection)
        .document(uid)
        .setData({'select_schedule_id': scheduleId}, merge: true);
  }

  @override
  Future<List<ScheduleSelectItemModel>> fetchEntrySchedule() async {
    var user = await fetchUser();
    if (user.uid.isEmpty) {
      throw UnLoginException();
    }
    var scheduleItems = List<ScheduleSelectItemModel>();
    var documents = (await _db
            .collection(_userCollection)
            .document(user.uid)
            .collection(_scheduleSubCollection)
            .getDocuments())
        .documents;
    for (var doc in documents) {
      // Reference型から直接データ参照できなかったため、
      // 冗長にデータを引っ張ってくる
      var docReference = doc.data['ref'];
      if (docReference is DocumentReference) {
        var scheduleDoc =
            await docReference.parent().document(docReference.documentID).get();
        var schedule = ScheduleEntity.fromMap(scheduleDoc.data);
        var item = ScheduleSelectItemModel.from(
            docReference.documentID, schedule, user);
        scheduleItems.add(item);
      }
    }
    return scheduleItems;
  }
}
