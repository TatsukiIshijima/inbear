import 'package:flutter/material.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/model/schedule.dart';
import 'package:inbear_app/repository/schedule_repository_impl.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/schedule_get_status.dart';
import 'package:intl/intl.dart';

class ScheduleViewModel extends ChangeNotifier {

  final UserRepositoryImpl _userRepositoryImpl;
  final ScheduleRepositoryImpl _scheduleRepositoryImpl;

  ScheduleViewModel(
    this._userRepositoryImpl,
    this._scheduleRepositoryImpl
  );

  final DateFormat _formatter = new DateFormat('yyyy年MM月dd日(E) HH:mm', 'ja_JP');

  ScheduleGetStatus status = ScheduleGetStatus.None;
  Schedule schedule;

  Future<void> fetchSelectSchedule() async {
    try {
      status = ScheduleGetStatus.Loading;
      notifyListeners();
      var user = await _userRepositoryImpl.fetchUser();
      schedule = await _scheduleRepositoryImpl.fetchSchedule(user.selectScheduleId);
      status = ScheduleGetStatus.Success;
      notifyListeners();
    } on UnLoginException {
      status = ScheduleGetStatus.Success;
      notifyListeners();
    } on DocumentNotExistException {
      status = ScheduleGetStatus.NotExistDocumentError;
      notifyListeners();
    } catch (exception) {
      status = ScheduleGetStatus.GeneralError;
      notifyListeners();
    }
  }

  String dateToString(DateTime dateTime) {
    return '${_formatter.format(dateTime)} ~';
  }
}