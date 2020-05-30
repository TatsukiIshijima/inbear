import 'dart:async';

import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/entity/user_entity.dart';
import 'package:inbear_app/repository/schedule_repository_impl.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/status.dart';
import 'package:inbear_app/viewmodel/base_viewmodel.dart';
import 'package:intl/intl.dart';

class ScheduleGetStatus extends Status {
  static const String noSelectScheduleError = 'NO_SELECT_SCHEDULE_ERROR';
}

class ScheduleViewModel extends BaseViewModel {
  final UserRepositoryImpl _userRepositoryImpl;
  final ScheduleRepositoryImpl _scheduleRepositoryImpl;

  ScheduleViewModel(this._userRepositoryImpl, this._scheduleRepositoryImpl);

  final DateFormat _formatter = DateFormat('yyyy年MM月dd日(E) HH:mm', 'ja_JP');

  ScheduleEntity schedule;

  Future<void> executeFetchSelectSchedule() async =>
      await executeFutureOperation(() => _fetchSelectSchedule());

  Future<void> _fetchSelectSchedule() async {
    try {
      final user =
          (await fromCancelable(_userRepositoryImpl.fetchUser())) as UserEntity;
      schedule = (await fromCancelable(
              _scheduleRepositoryImpl.fetchSchedule(user.selectScheduleId)))
          as ScheduleEntity;
      status = Status.success;
    } on NoSelectScheduleException {
      status = ScheduleGetStatus.noSelectScheduleError;
    }
    notifyListeners();
  }

  String dateToString(DateTime dateTime) {
    return '${_formatter.format(dateTime)} ~';
  }
}
