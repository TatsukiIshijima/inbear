import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/entity/user_entity.dart';
import 'package:inbear_app/repository/schedule_repository_impl.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/viewmodel/base_viewmodel.dart';

import '../status.dart';

class ParticipantListViewModel extends BaseViewModel {
  final UserRepositoryImpl _userRepositoryImpl;
  final ScheduleRepositoryImpl _scheduleRepositoryImpl;

  ParticipantListViewModel(
      this._userRepositoryImpl, this._scheduleRepositoryImpl);

  final _participantsStreamController = StreamController<List<UserEntity>>();
  final List<UserEntity> _participants = <UserEntity>[];
  final scrollController = ScrollController();

  Stream<List<UserEntity>> get participantsStream =>
      _participantsStreamController.stream;
  StreamSink<List<UserEntity>> get participantsSink =>
      _participantsStreamController.sink;

  bool isOwnerSchedule = false;
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
        await _executeFetchParticipantsNext();
        _isLoading = false;
      }
    });
  }

  Future<void> executeFetchParticipantsStart() async {
    await executeFutureOperation(() => _fetchParticipantsStart());
  }

  Future<void> _fetchParticipantsStart() async {
    try {
      if (_participantsStreamController.isClosed) {
        status = Status.none;
        notifyListeners();
        return;
      }
      final user =
          (await fromCancelable(_userRepositoryImpl.fetchUser())) as UserEntity;
      if (user.selectScheduleId.isEmpty) {
        throw NoSelectScheduleException();
      }
      final participantDocuments = (await fromCancelable(_scheduleRepositoryImpl
              .fetchParticipantsAtStart(user.selectScheduleId)))
          as List<DocumentSnapshot>;
      if (participantDocuments.isEmpty) {
        throw ParticipantsEmptyException();
      }
      final participantList = participantDocuments
          .map((doc) => UserEntity.fromMap(doc.data))
          .toList();
      _participants.clear();
      _participants.addAll(participantList);
      participantsSink.add(_participants);
      _lastSnapshot = participantDocuments.last;
      status = Status.success;
    } on NoSelectScheduleException {
      participantsSink.addError(NoSelectScheduleException());
      status = Status.none;
    } on ParticipantsEmptyException {
      participantsSink.addError(ParticipantsEmptyException());
      status = Status.none;
    }
    notifyListeners();
  }

  Future<void> _executeFetchParticipantsNext() async {
    await executeFutureOperation(() => _fetchParticipantsNext());
  }

  Future<void> _fetchParticipantsNext() async {
    try {
      if (_participantsStreamController.isClosed || _lastSnapshot == null) {
        status = Status.none;
        notifyListeners();
        return;
      }
      final selectScheduleId =
          (await _userRepositoryImpl.fetchUser()).selectScheduleId;
      if (selectScheduleId.isEmpty) {
        throw NoSelectScheduleException();
      }
      final participantDocuments = await _scheduleRepositoryImpl
          .fetchParticipantsNext(selectScheduleId, _lastSnapshot);
      if (participantDocuments.isEmpty) {
        _lastSnapshot = null;
        status = Status.none;
        notifyListeners();
        return;
      }
      final _participants = participantDocuments
          .map((doc) => UserEntity.fromMap(doc.data))
          .toList();
      _participants.addAll(_participants);
      participantsSink.add(_participants);
      _lastSnapshot = participantDocuments.last;
      status = Status.success;
      debugPrint('追加読み込み, ${_participants.length}');
    } on NoSelectScheduleException {
      participantsSink.addError(NoSelectScheduleException());
      status = Status.none;
    }
    notifyListeners();
  }

  Future<void> checkScheduleOwner() async {
    try {
      final user =
          (await fromCancelable(_userRepositoryImpl.fetchUser())) as UserEntity;
      if (user.selectScheduleId.isEmpty) {
        throw NoSelectScheduleException();
      }
      final schedule = (await fromCancelable(
              _scheduleRepositoryImpl.fetchSchedule(user.selectScheduleId)))
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
