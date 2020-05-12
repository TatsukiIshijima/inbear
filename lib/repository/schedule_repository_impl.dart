import 'package:inbear_app/entity/image_entity.dart';
import 'package:inbear_app/entity/schedule_entity.dart';

class ScheduleRepositoryImpl {
  Future<String> registerSchedule(ScheduleEntity schedule) {}
  Future<ScheduleEntity> fetchSchedule(String selectScheduleId) {}
  Future<void> postImages(String selectScheduleId, List<ImageEntity> images) {}
}