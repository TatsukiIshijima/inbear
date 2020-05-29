import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inbear_app/entity/image_entity.dart';
import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/entity/user_entity.dart';

abstract class ScheduleRepositoryImpl {
  Future<String> registerSchedule(ScheduleEntity schedule, UserEntity user,
      {bool isUpdate = false});
  Future<ScheduleEntity> fetchSchedule(String selectScheduleId);
  Future<void> postImages(String selectScheduleId, List<ImageEntity> images);
  Future<List<DocumentSnapshot>> fetchImagesAtStart(String selectScheduleId);
  Future<List<DocumentSnapshot>> fetchImagesNext(
      String selectScheduleId, DocumentSnapshot startSnapshot);
  Future<List<DocumentSnapshot>> fetchParticipantsAtStart(
      String selectScheduleId);
  Future<List<DocumentSnapshot>> fetchParticipantsNext(
      String selectScheduleId, DocumentSnapshot startSnapshot);
  Future<List<UserEntity>> convertToParticipantUsers(
      List<DocumentSnapshot> participantDocuments);
  Future<bool> isParticipantUser(String selectScheduleId, String uid);
  Future<void> addParticipant(String selectScheduleId, String uid);
  Future<void> deleteParticipant(String selectScheduleId, String uid);
}
