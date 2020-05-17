import 'package:flutter/material.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/repository/schedule_repository_impl.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/status.dart';
import 'package:intl/intl.dart';

class ScheduleGetStatus extends Status {
  static const String notExistUserDataError = 'NOT_EXIST_USER_DATA_ERROR';
  static const String notExistScheduleDataError =
      'NOT_EXIST_SCHEDULE_DATA_ERROR';
  static const String noSelectScheduleError = 'NO_SELECT_SCHEDULE_ERROR';
}

class ScheduleViewModel extends ChangeNotifier {
  final UserRepositoryImpl _userRepositoryImpl;
  final ScheduleRepositoryImpl _scheduleRepositoryImpl;

  ScheduleViewModel(this._userRepositoryImpl, this._scheduleRepositoryImpl);

  final DateFormat _formatter = DateFormat('yyyy年MM月dd日(E) HH:mm', 'ja_JP');

  String status = Status.none;
  ScheduleEntity schedule;

  Future<void> fetchSelectSchedule() async {
    try {
      status = Status.loading;
      notifyListeners();
      var user = await _userRepositoryImpl.fetchUser();
      schedule =
          await _scheduleRepositoryImpl.fetchSchedule(user.selectScheduleId);
      status = Status.success;
    } on UnLoginException {
      status = Status.unLoginError;
    } on UserDocumentNotExistException {
      status = ScheduleGetStatus.notExistUserDataError;
    } on ScheduleDocumentNotExistException {
      status = ScheduleGetStatus.notExistScheduleDataError;
    } on NoSelectScheduleException {
      status = ScheduleGetStatus.noSelectScheduleError;
    }
    notifyListeners();
  }

  String dateToString(DateTime dateTime) {
    return '${_formatter.format(dateTime)} ~';
  }
}
