import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/model/schedule.dart';
import 'package:inbear_app/repository/schedule_repository_impl.dart';

class ScheduleRepository implements ScheduleRepositoryImpl {

  final FirebaseAuth _auth;
  final Firestore _db;
  final String _scheduleCollection = 'schedule';
  final String _participantSubCollection = 'participant';

  ScheduleRepository(this._auth, this._db);

  @override
  Future<String> registerSchedule(Schedule schedule) async {
    var user = await _auth.currentUser();
    if (user == null) {
      throw UnLoginException();
    }
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
  Future<Schedule> fetchSchedule(String selectScheduleId) async {
    var scheduleDocument = await _db.collection(_scheduleCollection)
        .document(selectScheduleId)
        .get();
    if (!scheduleDocument.exists) {
      throw DocumentNotExistException();
    }
    return (Schedule.fromMap(scheduleDocument.data));
  }

}