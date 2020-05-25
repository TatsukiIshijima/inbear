import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/entity/user_entity.dart';

class ParticipantDeleteItemModel {
  final String uid;
  final String name;
  final String email;
  final bool isOwner;

  ParticipantDeleteItemModel(this.uid, this.name, this.email, this.isOwner);

  factory ParticipantDeleteItemModel.from(
      UserEntity userEntity, ScheduleEntity scheduleEntity) {
    final isOwner = userEntity.uid == scheduleEntity.ownerUid;
    return ParticipantDeleteItemModel(
        userEntity.uid, userEntity.name, userEntity.email, isOwner);
  }
}
