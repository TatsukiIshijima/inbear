import 'package:inbear_app/repository/address_repository_impl.dart';
import 'package:inbear_app/repository/schedule_repository_impl.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/viewmodel/schedule_register_viewmodel.dart';

class ScheduleEditViewModel extends ScheduleRegisterViewModel {
  ScheduleEditViewModel(
      UserRepositoryImpl userRepositoryImpl,
      ScheduleRepositoryImpl scheduleRepositoryImpl,
      AddressRepositoryImpl addressRepositoryImpl)
      : super(
            userRepositoryImpl, scheduleRepositoryImpl, addressRepositoryImpl);
}
