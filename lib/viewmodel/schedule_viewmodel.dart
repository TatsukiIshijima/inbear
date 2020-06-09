import 'dart:async';

import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/entity/user_entity.dart';
import 'package:inbear_app/exception/auth/auth_exception.dart';
import 'package:inbear_app/exception/database/firestore_exception.dart';
import 'package:inbear_app/repository/schedule_repository_impl.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/status.dart';
import 'package:inbear_app/viewmodel/base_viewmodel.dart';
import 'package:intl/intl.dart';

class ScheduleStatus extends Status {
  ScheduleStatus(String value) : super(value);

  static const fetchSelectScheduleSuccess =
      Status('FETCH_SELECT_SCHEDULE_SUCCESS');
  static const noSelectScheduleError = Status('NO_SELECT_SCHEDULE_ERROR');
}

class ScheduleViewModel extends BaseViewModel {
  final UserRepositoryImpl _userRepositoryImpl;
  final ScheduleRepositoryImpl _scheduleRepositoryImpl;

  ScheduleViewModel(this._userRepositoryImpl, this._scheduleRepositoryImpl);

  final DateFormat _formatter = DateFormat('yyyy年MM月dd日(E) HH:mm', 'ja_JP');

  ScheduleEntity schedule;
  bool isOwnerSchedule = false;

  Future<void> executeFetchSelectSchedule() async =>
      await executeFutureOperation(() => _fetchSelectSchedule());

  Future<void> _fetchSelectSchedule() async {
    try {
      final user =
          (await fromCancelable(_userRepositoryImpl.fetchUser())) as UserEntity;
      schedule = (await fromCancelable(
              _scheduleRepositoryImpl.fetchSchedule(user.selectScheduleId)))
          as ScheduleEntity;
      status = ScheduleStatus.fetchSelectScheduleSuccess;
    } on NoSelectScheduleException {
      status = ScheduleStatus.noSelectScheduleError;
    }
    notifyListeners();
  }

  String dateToString(DateTime dateTime) {
    return '${_formatter.format(dateTime)} ~';
  }

  Future<void> checkScheduleOwner() async {
    try {
      final user =
          await fromCancelable(_userRepositoryImpl.fetchUser()) as UserEntity;
      if (user.selectScheduleId.isEmpty) {
        throw NoSelectScheduleException();
      }
      final schedule = await fromCancelable(
              _scheduleRepositoryImpl.fetchSchedule(user.selectScheduleId))
          as ScheduleEntity;
      isOwnerSchedule = schedule.ownerUid == user.uid;
    } on UnLoginException {
      isOwnerSchedule = false;
    } on UserDocumentNotExistException {
      isOwnerSchedule = false;
    } on NoSelectScheduleException {
      isOwnerSchedule = false;
    } on TimeoutException {
      isOwnerSchedule = false;
    }
    notifyListeners();
  }
}
