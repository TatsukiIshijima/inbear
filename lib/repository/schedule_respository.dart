import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/entity/image_entity.dart';
import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/entity/user_entity.dart';
import 'package:inbear_app/repository/schedule_repository_impl.dart';

class ScheduleRepository implements ScheduleRepositoryImpl {
  final FirebaseAuth _auth;
  final Firestore _db;
  final String _scheduleCollection = 'schedule';
  final String _participantSubCollection = 'participant';
  final String _imageSubCollection = 'image';

  ScheduleRepository(this._auth, this._db);

  final Map<String, ScheduleEntity> _scheduleCache = {};

  @override
  Future<String> registerSchedule(ScheduleEntity schedule, UserEntity user,
      {bool isUpdate = false}) async {
    final document =
        await _db.collection(_scheduleCollection).add(schedule.toMap());
    await _db
        .collection(_scheduleCollection)
        .document(document.documentID)
        .collection(_participantSubCollection)
        .document(user.uid)
        .setData(user.toMap(), merge: isUpdate)
        .timeout(Duration(seconds: 5),
            onTimeout: () => throw TimeoutException(
                'ScheduleRepository: registerSchedule Timeout.'));
    return document.documentID;
  }

  @override
  Future<ScheduleEntity> fetchSchedule(String selectScheduleId) async {
    if (selectScheduleId.isEmpty) {
      throw NoSelectScheduleException();
    }
    if (_scheduleCache.containsKey(selectScheduleId)) {
      return _scheduleCache[selectScheduleId];
    }
    final scheduleDocument = await _db
        .collection(_scheduleCollection)
        .document(selectScheduleId)
        .get()
        .timeout(Duration(seconds: 5),
            onTimeout: () =>
                throw TimeoutException('fetch schedule document time out.'));
    if (!scheduleDocument.exists) {
      throw ScheduleDocumentNotExistException();
    }
    _scheduleCache.clear();
    _scheduleCache[selectScheduleId] =
        ScheduleEntity.fromMap(scheduleDocument.data);
    return _scheduleCache[selectScheduleId];
  }

  @override
  Future<void> postImages(
      String selectScheduleId, List<ImageEntity> images) async {
    final batch = _db.batch();
    for (var image in images) {
      final imageReference = _db
          .collection(_scheduleCollection)
          .document(selectScheduleId)
          .collection(_imageSubCollection)
          .document();
      batch.setData(imageReference, image.toMap());
    }
    await batch.commit();
  }

  @override
  Future<List<DocumentSnapshot>> fetchImagesAtStart(
      String selectScheduleId) async {
    return (await _db
            .collection(_scheduleCollection)
            .document(selectScheduleId)
            .collection(_imageSubCollection)
            .orderBy('created_at', descending: true)
            .limit(20)
            .getDocuments()
            .timeout(Duration(seconds: 5),
                onTimeout: () => throw TimeoutException(
                    'ScheduleRepository: fetchImagesAtStart Timeout.')))
        .documents;
  }

  @override
  Future<List<DocumentSnapshot>> fetchImagesNext(
      String selectScheduleId, DocumentSnapshot startSnapshot) async {
    return (await _db
            .collection(_scheduleCollection)
            .document(selectScheduleId)
            .collection(_imageSubCollection)
            .orderBy('created_at', descending: true)
            .limit(20)
            .startAfterDocument(startSnapshot)
            .getDocuments()
            .timeout(Duration(seconds: 5),
                onTimeout: () => throw TimeoutException(
                    'ScheduleRepository: fetchImagesNext Timeout.')))
        .documents;
  }

  @override
  Future<List<DocumentSnapshot>> fetchParticipantsAtStart(
      String selectScheduleId) async {
    return (await _db
            .collection(_scheduleCollection)
            .document(selectScheduleId)
            .collection(_participantSubCollection)
            .orderBy('name', descending: true)
            .limit(10)
            .getDocuments()
            .timeout(Duration(seconds: 5),
                onTimeout: () => throw TimeoutException(
                    'ScheduleRepository: fetchParticipantsAtStart Timeout.')))
        .documents;
  }

  @override
  Future<List<DocumentSnapshot>> fetchParticipantsNext(
      String selectScheduleId, DocumentSnapshot startSnapshot) async {
    return (await _db
            .collection(_scheduleCollection)
            .document(selectScheduleId)
            .collection(_participantSubCollection)
            .orderBy('name', descending: true)
            .limit(10)
            .startAfterDocument(startSnapshot)
            .getDocuments()
            .timeout(Duration(seconds: 5),
                onTimeout: () => throw TimeoutException(
                    'ScheduleRepository fetchParticipantsNext Timeout.')))
        .documents;
  }

  @override
  Future<bool> isParticipantUser(String selectScheduleId, String uid) async {
    final participantDocument = await _db
        .collection(_scheduleCollection)
        .document(selectScheduleId)
        .collection(_participantSubCollection)
        .document(uid)
        .get()
        .timeout(Duration(seconds: 5),
            onTimeout: () =>
                throw TimeoutException('is participant user time out.'));
    return participantDocument.exists;
  }

  @override
  Future<void> addParticipant(String selectScheduleId, String uid) async {
    const _userCollection = 'user';
    final userReference = _db.collection(_userCollection).document(uid);
    await _db
        .collection(_scheduleCollection)
        .document(selectScheduleId)
        .collection(_participantSubCollection)
        .document(uid)
        .setData(<String, DocumentReference>{'ref': userReference},
            merge:
                true).timeout(Duration(seconds: 5),
            onTimeout: () =>
                throw TimeoutException('add participant time out.'));
  }

  @override
  Future<void> deleteParticipant(String selectScheduleId, String uid) async {
    await _db
        .collection(_scheduleCollection)
        .document(selectScheduleId)
        .collection(_participantSubCollection)
        .document(uid)
        .delete()
        .timeout(Duration(seconds: 5),
            onTimeout: () =>
                throw TimeoutException('delete participant time out.'));
  }
}
