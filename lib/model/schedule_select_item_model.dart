import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/entity/user_entity.dart';

class ScheduleSelectItemModel {

  final String id;
  final bool isSelected;
  final String pairName;

  ScheduleSelectItemModel(
    this.id,
    this.isSelected,
    this.pairName
  );
  
  factory ScheduleSelectItemModel.from(
      String scheduleDocumentId,
      ScheduleEntity scheduleEntity,
      UserEntity userEntity) {
    var isSelected = scheduleDocumentId == userEntity.selectScheduleId;
    var pairName = '${scheduleEntity.groom} & ${scheduleEntity.bride}';
    return ScheduleSelectItemModel(scheduleDocumentId, isSelected, pairName);
  }
}