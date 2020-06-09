import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inbear_app/entity/image_entity.dart';
import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/entity/user_entity.dart';
import 'package:inbear_app/exception/database/firestore_exception.dart';
import 'package:inbear_app/repository/schedule_repository_impl.dart';

class ScheduleRepository implements ScheduleRepositoryImpl {
  final Firestore _db;
  final String _scheduleCollection = 'schedule';
  final String _participantSubCollection = 'participant';
  final String _imageSubCollection = 'image';

  ScheduleRepository(this._db);

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
  Future<void> updateSchedule(ScheduleEntity schedule, UserEntity user) async {
    await _db
        .collection(_scheduleCollection)
        .document(user.selectScheduleId)
        .updateData(schedule.toMap())
        .timeout(Duration(seconds: 5),
            onTimeout: () => throw TimeoutException(
                'ScheduleRepository: updateSchedule Timeout.'));
    // 更新後に取得する場合にキャッシュが残ったままだと、以前のデータを取得してしまうので
    // キャッシュを削除
    _scheduleCache.clear();
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
            onTimeout: () => throw TimeoutException(
                'ScheduleRepository: fetchSchedule Timeout.'));
    if (!scheduleDocument.exists) {
      throw ScheduleDocumentNotExistException();
    }
    _scheduleCache.clear();
    _scheduleCache[selectScheduleId] =
        ScheduleEntity.fromMap(scheduleDocument.data);
    return _scheduleCache[selectScheduleId];
  }

  @override
  Future<void> postImage(
      String selectScheduleId, ImageEntity imageEntity) async {
    await _db
        .collection(_scheduleCollection)
        .document(selectScheduleId)
        .collection(_imageSubCollection)
        .document()
        .setData(imageEntity.toMap())
        .timeout(Duration(seconds: 5),
            onTimeout: () => throw TimeoutException(
                'ScheduleRepository: postImage Timeout.'));
  }

  @override
  Future<void> deleteImage(
      String selectScheduleId, String imageDocumentId) async {
    await _db
        .collection(_scheduleCollection)
        .document(selectScheduleId)
        .collection(_imageSubCollection)
        .document(imageDocumentId)
        .delete()
        .timeout(Duration(seconds: 5),
            onTimeout: () => throw TimeoutException(
                'ScheduleRepository: deleteImage Timeout.'));
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
                    'ScheduleRepository: fetchParticipantsNext Timeout.')))
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
            onTimeout: () => throw TimeoutException(
                'ScheduleRepository: isParticipantUser Timeout.'));
    return participantDocument.exists;
  }

  @override
  Future<void> addParticipant(String selectScheduleId, String targetUid) async {
    const _userCollection = 'user';
    // participantコレクション配下に書き込む UserData で SelectScheduleID は使用しないので、
    // スケジュール切り替えがあったとしても値を書き換えない participants コレクション配下の UserData の更新はしない
    // UserData の master は user コレクション
    final user = await _db
        .collection(_userCollection)
        .document(targetUid)
        .get()
        .timeout(Duration(seconds: 5),
            onTimeout: () => throw TimeoutException(
                'ScheduleRepository: addParticipant Timeout.'));
    await _db
        .collection(_scheduleCollection)
        .document(selectScheduleId)
        .collection(_participantSubCollection)
        .document(targetUid)
        .setData(user.data, merge: true)
        .timeout(Duration(seconds: 5),
            onTimeout: () => throw TimeoutException(
                'ScheduleRepository: addParticipant Timeout.'));
  }

  @override
  Future<void> deleteParticipant(
      String selectScheduleId, String targetUid) async {
    await _db
        .collection(_scheduleCollection)
        .document(selectScheduleId)
        .collection(_participantSubCollection)
        .document(targetUid)
        .delete()
        .timeout(Duration(seconds: 5),
            onTimeout: () => throw TimeoutException(
                'ScheduleRepository: deleteParticipant Timeout.'));
  }
}
