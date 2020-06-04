import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inbear_app/entity/image_entity.dart';
import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/entity/user_entity.dart';

abstract class ScheduleRepositoryImpl {
  Future<String> registerSchedule(ScheduleEntity schedule, UserEntity user,
      {bool isUpdate = false});
  Future<ScheduleEntity> fetchSchedule(String selectScheduleId);
  Future<void> postImage(String selectScheduleId, ImageEntity imageEntity);
  Future<void> deleteImage(String selectScheduleId, String imageDocumentId);
  Future<List<DocumentSnapshot>> fetchImagesAtStart(String selectScheduleId);
  Future<List<DocumentSnapshot>> fetchImagesNext(
      String selectScheduleId, DocumentSnapshot startSnapshot);
  Future<List<DocumentSnapshot>> fetchParticipantsAtStart(
      String selectScheduleId);
  Future<List<DocumentSnapshot>> fetchParticipantsNext(
      String selectScheduleId, DocumentSnapshot startSnapshot);
  Future<bool> isParticipantUser(String selectScheduleId, String uid);
  Future<void> addParticipant(String selectScheduleId, String targetUid);
  Future<void> deleteParticipant(String selectScheduleId, String targetUid);
}
