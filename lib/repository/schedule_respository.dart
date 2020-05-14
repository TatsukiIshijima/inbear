import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/entity/image_entity.dart';
import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/repository/schedule_repository_impl.dart';

class ScheduleRepository implements ScheduleRepositoryImpl {

  final FirebaseAuth _auth;
  final Firestore _db;
  final String _scheduleCollection = 'schedule';
  final String _participantSubCollection = 'participant';
  final String _imageSubCollection = 'image';

  ScheduleRepository(this._auth, this._db);

  @override
  Future<String> registerSchedule(ScheduleEntity schedule) async {
    var user = await _auth.currentUser();
    if (user == null) {
      throw UnLoginException();
    }
    // FIXME:batchで書き直せるかも
    var document = await _db.collection(_scheduleCollection)
        .add(schedule.toMap());
    const String _userCollection = 'user';
    var userReference = _db.collection(_userCollection)
        .document(user.uid);
    await _db.collection(_scheduleCollection)
        .document(document.documentID)
        .collection(_participantSubCollection)
        .document(user.uid)
        .setData({'ref': userReference});
    return document.documentID;
  }

  @override
  Future<ScheduleEntity> fetchSchedule(String selectScheduleId) async {
    if (selectScheduleId.isEmpty) {
      throw NoSelectScheduleException();
    }
    var scheduleDocument = await _db.collection(_scheduleCollection)
        .document(selectScheduleId)
        .get();
    if (!scheduleDocument.exists) {
      throw DocumentNotExistException();
    }
    return (ScheduleEntity.fromMap(scheduleDocument.data));
  }

  @override
  Future<void> postImages(String selectScheduleId, List<ImageEntity> images) async {
    final WriteBatch batch = _db.batch();
    for (var image in images) {
      final imageReference = _db.collection(_scheduleCollection)
          .document(selectScheduleId)
          .collection(_imageSubCollection)
          .document();
      batch.setData(imageReference, image.toMap());
    }
    await batch.commit();
  }

  @override
  Future<List<DocumentSnapshot>> fetchImagesAtStart(String selectScheduleId) async {
    return (await _db.collection(_scheduleCollection)
        .document(selectScheduleId)
        .collection(_imageSubCollection)
        .limit(20)
        .getDocuments()).documents;
  }

  @override
  Future<List<DocumentSnapshot>> fetchImagesNext(
      String selectScheduleId,
      DocumentSnapshot startSnapshot) async {
    return (await _db.collection(_scheduleCollection)
        .document(selectScheduleId)
        .collection(_imageSubCollection)
        .limit(20)
        .orderBy('created_at', descending: true)
        .getDocuments()).documents;
  }

}