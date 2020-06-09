import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/entity/user_entity.dart';
import 'package:inbear_app/repository/address_repository_impl.dart';
import 'package:inbear_app/repository/schedule_repository_impl.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/viewmodel/schedule_register_viewmodel.dart';

import '../status.dart';

class ScheduleEditStatus extends Status {
  ScheduleEditStatus(String value) : super(value);

  static const updateScheduleSuccess = Status('UPDATE_SCHEDULE_SUCCESS');
}

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
    addressGeoPoint = scheduleEntity.geoPoint;
  }

  Future<void> executeUpdateSchedule() async =>
      await executeFutureOperation(() => _updateSchedule());

  Future<void> _updateSchedule() async {
    if (scheduledDateTime == null) {
      status = ScheduleRegisterStatus.unSelectDateError;
      notifyListeners();
      return;
    }
    if (addressGeoPoint == null) {
      status = ScheduleRegisterStatus.unableSearchAddressError;
      notifyListeners();
      return;
    }
    final user =
        await fromCancelable(userRepositoryImpl.fetchUser()) as UserEntity;
    final newSchedule = ScheduleEntity(
        groomTextEditingController.text,
        brideTextEditingController.text,
        scheduledDateTime,
        addressTextEditingController.text,
        addressGeoPoint,
        user.uid,
        scheduleEntity.createdAt,
        DateTime.now());
    await fromCancelable(
        scheduleRepositoryImpl.updateSchedule(newSchedule, user));
    await fromCancelable(
        userRepositoryImpl.updateSchedule(user.selectScheduleId, newSchedule));
    status = ScheduleEditStatus.updateScheduleSuccess;
    notifyListeners();
  }
}
