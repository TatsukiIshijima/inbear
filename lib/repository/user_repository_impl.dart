import 'package:inbear_app/entity/user_entity.dart';
import 'package:inbear_app/model/schedule_select_item_model.dart';

class UserRepositoryImpl {
  Future<String> signIn(String email, String password) {}
  Future<String> signUp(String name, String email, String password) {}
  Future<void> signOut() {}
  Future<bool> isSignIn() {}
  Future<String> sendPasswordResetEmail(String email) {}
  Future<String> getUid() {}
  Future<UserEntity> fetchUser() {}
  Future<void> addScheduleReference(String scheduleId) {}
  Future<void> selectSchedule(String scheduleId) {}
  Future<List<ScheduleSelectItemModel>> fetchEntrySchedule() {}
}