import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/repository/address_repository_impl.dart';
import 'package:inbear_app/repository/schedule_repository_impl.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/viewmodel/schedule_register_viewmodel.dart';

class ScheduleEditViewModel extends ScheduleRegisterViewModel {
  final ScheduleEntity scheduleEntity;

  ScheduleEditViewModel(
      UserRepositoryImpl userRepositoryImpl,
      ScheduleRepositoryImpl scheduleRepositoryImpl,
      AddressRepositoryImpl addressRepositoryImpl,
      this.scheduleEntity)
      : super(
            userRepositoryImpl, scheduleRepositoryImpl, addressRepositoryImpl);

  void initForm() {
    groomTextEditingController.text = scheduleEntity.groom;
    brideTextEditingController.text = scheduleEntity.bride;
    addressTextEditingController.text = scheduleEntity.address;
    updateDate(scheduleEntity.dateTime);
  }
}
