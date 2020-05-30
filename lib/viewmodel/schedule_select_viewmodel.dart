import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/entity/user_entity.dart';
import 'package:inbear_app/model/schedule_select_item_model.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/status.dart';
import 'package:inbear_app/viewmodel/base_viewmodel.dart';

class ScheduleSelectViewModel extends BaseViewModel {
  final UserRepositoryImpl _userRepositoryImpl;

  ScheduleSelectViewModel(
    this._userRepositoryImpl,
  );

  List<ScheduleSelectItemModel> scheduleItems = <ScheduleSelectItemModel>[];

  Future<void> fetchEntrySchedule() async {
    await executeFutureOperation(() => _fetchEntrySchedule());
  }

  Future<void> _fetchEntrySchedule() async {
    scheduleItems.clear();
    final scheduleSelectItems = await _toScheduleSelectItemModels();
    scheduleItems.addAll(scheduleSelectItems);
    status = Status.success;
    notifyListeners();
  }

  Future<List<ScheduleSelectItemModel>> _toScheduleSelectItemModels() async {
    const documentIdKey = 'document_id';
    const scheduleKey = 'schedule';
    final user =
        (await fromCancelable(_userRepositoryImpl.fetchUser())) as UserEntity;
    final entryScheduleDocs =
        (await fromCancelable(_userRepositoryImpl.fetchEntrySchedule()))
            as List<DocumentSnapshot>;
    final scheduleMaps = entryScheduleDocs
        .map((doc) => {
              documentIdKey: doc.documentID,
              scheduleKey: ScheduleEntity.fromMap(doc.data)
            })
        .toList();
    final scheduleSelectItems = scheduleMaps
        .map((map) => ScheduleSelectItemModel.from(map[documentIdKey] as String,
            map[scheduleKey] as ScheduleEntity, user))
        .toList();
    return scheduleSelectItems;
  }

  Future<void> selectSchedule(String scheduleId) async {
    await executeFutureOperation(() => _selectSchedule(scheduleId));
  }

  Future<void> _selectSchedule(String scheduleId) async {
    await fromCancelable(_userRepositoryImpl.selectSchedule(scheduleId));
    await _fetchEntrySchedule();
  }
}
