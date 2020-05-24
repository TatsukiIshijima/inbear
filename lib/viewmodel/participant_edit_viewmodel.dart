import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/entity/user_entity.dart';
import 'package:inbear_app/repository/schedule_repository_impl.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/viewmodel/base_viewmodel.dart';

class ParticipantEditViewModel extends BaseViewModel {
  final UserRepositoryImpl _userRepositoryImpl;
  final ScheduleRepositoryImpl _scheduleRepositoryImpl;

  ParticipantEditViewModel(
      this._userRepositoryImpl, this._scheduleRepositoryImpl);

  final _participantsStreamController = StreamController<List<UserEntity>>();
  //final List<UserEntity> _participants = <UserEntity>[];
  final scrollController = ScrollController();

  Stream<List<UserEntity>> get participantsStream =>
      _participantsStreamController.stream;
  StreamSink<List<UserEntity>> get participantsSink =>
      _participantsStreamController.sink;

  @override
  void dispose() {
    _participantsStreamController.close();
    participantsSink.close();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchParticipants() async {
    debugPrint('fetchParticipants');
  }

  Future<void> deleteParticipant(String targetUid) async {
    try {
      final userSelf = await _userRepositoryImpl.fetchUser();
      await _scheduleRepositoryImpl.deleteParticipant(
          userSelf.selectScheduleId, targetUid);
    } on UnLoginException {} on UserDocumentNotExistException {} on TimeoutException {}
  }
}
