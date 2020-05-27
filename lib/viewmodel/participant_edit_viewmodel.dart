import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/model/participant_item_model.dart';
import 'package:inbear_app/repository/schedule_repository_impl.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/viewmodel/base_viewmodel.dart';

class ParticipantEditViewModel extends BaseViewModel {
  final UserRepositoryImpl _userRepositoryImpl;
  final ScheduleRepositoryImpl _scheduleRepositoryImpl;

  ParticipantEditViewModel(
      this._userRepositoryImpl, this._scheduleRepositoryImpl);

  final _participantsStreamController =
      StreamController<List<ParticipantItemModel>>();
  final List<ParticipantItemModel> _participants = <ParticipantItemModel>[];
  final scrollController = ScrollController();

  Stream<List<ParticipantItemModel>> get participantsStream =>
      _participantsStreamController.stream;
  StreamSink<List<ParticipantItemModel>> get participantsSink =>
      _participantsStreamController.sink;

  DocumentSnapshot _lastSnapshot;
  bool _isLoading = false;

  @override
  void dispose() {
    _participantsStreamController.close();
    participantsSink.close();
    scrollController.dispose();
    super.dispose();
  }

  void setScrollListener() {
    scrollController.addListener(() async {
      final maxScrollExtent = scrollController.position.maxScrollExtent;
      if (scrollController.offset >= maxScrollExtent && !_isLoading) {
        _isLoading = true;
        await fromCancelable(_fetchParticipantsNext());
        _isLoading = false;
      }
    });
  }

  Future<void> fetchParticipantsStart() async {
    await fromCancelable(_fetchParticipantsStart());
  }

  Future<void> _fetchParticipantsStart() async {
    try {
      _participants.clear();
      final selectScheduleId =
          (await _userRepositoryImpl.fetchUser()).selectScheduleId;
      if (selectScheduleId.isEmpty) {
        throw NoSelectScheduleException();
      }
      final participantDocuments = await _scheduleRepositoryImpl
          .fetchParticipantsAtStart(selectScheduleId);
      if (participantDocuments.isEmpty) {
        throw ParticipantsEmptyException();
      }
      final selectScheduleEntity =
          await _scheduleRepositoryImpl.fetchSchedule(selectScheduleId);
      final participantUserEntities = await _scheduleRepositoryImpl
          .convertToParticipantUsers(participantDocuments);
      final participantDeleteModels = participantUserEntities
          .map((userEntity) =>
              ParticipantItemModel.from(userEntity, selectScheduleEntity))
          .toList();
      _participants.addAll(participantDeleteModels);
      if (_participantsStreamController.isClosed) {
        return;
      }
      participantsSink.add(_participants);
      _lastSnapshot = participantDocuments.last;
    } on UnLoginException {
      participantsSink.addError(UnLoginException());
    } on UserDocumentNotExistException {
      participantsSink.addError(UserDocumentNotExistException());
    } on NoSelectScheduleException {
      participantsSink.addError(NoSelectScheduleException());
    } on ParticipantsEmptyException {
      participantsSink.addError(ParticipantsEmptyException());
    } on ScheduleDocumentNotExistException {
      participantsSink.addError(ScheduleDocumentNotExistException());
    } on TimeoutException {
      participantsSink
          .addError(TimeoutException('fetch participants start time out.'));
    }
  }

  Future<void> _fetchParticipantsNext() async {
    try {
      final selectScheduleId =
          (await _userRepositoryImpl.fetchUser()).selectScheduleId;
      if (selectScheduleId.isEmpty) {
        throw NoSelectScheduleException();
      }
      if (_lastSnapshot == null) {
        return;
      }
      final participantDocuments = await _scheduleRepositoryImpl
          .fetchParticipantsNext(selectScheduleId, _lastSnapshot);
      if (participantDocuments.isEmpty) {
        _lastSnapshot = null;
        return;
      }
      final selectScheduleEntity =
          await _scheduleRepositoryImpl.fetchSchedule(selectScheduleId);
      final participantUserEntities = await _scheduleRepositoryImpl
          .convertToParticipantUsers(participantDocuments);
      final participantDeleteModels = participantUserEntities
          .map((userEntity) =>
              ParticipantItemModel.from(userEntity, selectScheduleEntity))
          .toList();
      _participants.addAll(participantDeleteModels);
      if (_participantsStreamController.isClosed) {
        return;
      }
      participantsSink.add(_participants);
      _lastSnapshot = participantDocuments.last;
      debugPrint('追加読み込み, ${_participants.length}');
    } on UnLoginException {
      participantsSink.addError(UnLoginException());
    } on UserDocumentNotExistException {
      participantsSink.addError(UserDocumentNotExistException());
    } on NoSelectScheduleException {
      participantsSink.addError(NoSelectScheduleException());
    } on ScheduleDocumentNotExistException {
      participantsSink.addError(ScheduleDocumentNotExistException());
    } on TimeoutException {
      participantsSink
          .addError(TimeoutException('fetch participants next time out.'));
    }
  }

  Future<void> deleteParticipant(String targetUid) async {
    await executeFutureOperation(() => _deleteParticipant(targetUid));
  }

  Future<void> _deleteParticipant(String targetUid) async {
    final userSelf = await _userRepositoryImpl.fetchUser();
    await _scheduleRepositoryImpl.deleteParticipant(
        userSelf.selectScheduleId, targetUid);
    await _userRepositoryImpl.deleteSchedule(
        targetUid, userSelf.selectScheduleId);
  }
}
