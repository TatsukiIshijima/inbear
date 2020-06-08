import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/entity/user_entity.dart';

abstract class UserRepositoryImpl {
  Future<void> signIn(String email, String password);
  Future<FirebaseUser> createUserWithEmailAndPassword(
      String email, String password);
  Future<void> insertNewUser(FirebaseUser user, String name);
  Future<void> signOut();
  Future<bool> isSignIn();
  Future<void> sendPasswordResetEmail(String email);
  Future<String> getUid();
  Future<UserEntity> fetchUser();
  Future<void> registerSchedule(
      String scheduleId, ScheduleEntity scheduleEntity,
      {bool isUpdate = false});
  Future<void> updateSchedule(String scheduleId, ScheduleEntity scheduleEntity);
  Future<void> selectSchedule(String scheduleId);
  Future<List<DocumentSnapshot>> fetchEntrySchedule();
  Future<List<UserEntity>> searchUser(String email);
  Future<void> addScheduleInUser(String targetUid, String targetScheduleId);
  Future<void> deleteScheduleInUser(String targetUid, String targetScheduleId);
  Future<void> clearSelectSchedule(String targetUid);
}
