import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/entity/user_entity.dart';

class ParticipantItemModel {
  final String uid;
  final String name;
  final String email;
  final bool isOwner;

  ParticipantItemModel(this.uid, this.name, this.email, this.isOwner);

  factory ParticipantItemModel.from(
      UserEntity userEntity, ScheduleEntity scheduleEntity) {
    final isOwner = userEntity.uid == scheduleEntity.ownerUid;
    return ParticipantItemModel(
        userEntity.uid, userEntity.name, userEntity.email, isOwner);
  }
}
