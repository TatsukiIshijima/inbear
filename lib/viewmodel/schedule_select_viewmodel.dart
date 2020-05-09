import 'package:flutter/material.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/model/schedule_select_item_model.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/status.dart';

class ScheduleSelectStatus extends Status {

}

class ScheduleSelectViewModel extends ChangeNotifier {

  final UserRepositoryImpl _userRepositoryImpl;

  ScheduleSelectViewModel(
    this._userRepositoryImpl,
  );

  String status = Status.none;
  List<ScheduleSelectItemModel> scheduleItems = List<ScheduleSelectItemModel>();

  Future<void> fetchEntrySchedule() async {
    try {
      status = Status.loading;
      notifyListeners();
      scheduleItems.clear();
      var entrySchedules = await _userRepositoryImpl.fetchEntrySchedule();
      scheduleItems.addAll(entrySchedules);
      status = Status.success;
    } on UnLoginException {
      status = Status.unLoginError;
    }
    notifyListeners();
  }

  Future<void> selectSchedule(String scheduleId) async {
    try {
      status = Status.loading;
      notifyListeners();
      await _userRepositoryImpl.selectSchedule(scheduleId);
      scheduleItems.clear();
      var entrySchedules = await _userRepositoryImpl.fetchEntrySchedule();
      scheduleItems.addAll(entrySchedules);
      status = Status.success;
    } on UnLoginException {
      status = Status.unLoginError;
    }
    notifyListeners();
  }
}