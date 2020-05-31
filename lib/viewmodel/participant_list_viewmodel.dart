import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/entity/user_entity.dart';
import 'package:inbear_app/model/participant_item_model.dart';
import 'package:inbear_app/repository/schedule_repository_impl.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/viewmodel/base_viewmodel.dart';

import '../status.dart';

class ParticipantListViewModel extends BaseViewModel {
  final UserRepositoryImpl _userRepositoryImpl;
  final ScheduleRepositoryImpl _scheduleRepositoryImpl;

  ParticipantListViewModel(
      this._userRepositoryImpl, this._scheduleRepositoryImpl);

  final _participantsStreamController =
      StreamController<List<ParticipantItemModel>>();
  final List<ParticipantItemModel> _participants = <ParticipantItemModel>[];
  final scrollController = ScrollController();

  Stream<List<ParticipantItemModel>> get participantsStream =>
      _participantsStreamController.stream;
  StreamSink<List<ParticipantItemModel>> get participantsSink =>
      _participantsStreamController.sink;

  bool isOwnerSchedule = false;
  DocumentSnapshot lastSnapshot;
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
      final selectScheduleId = await _getSelectScheduleId();
      final selectScheduleEntity = (await fromCancelable(
              _scheduleRepositoryImpl.fetchSchedule(selectScheduleId)))
          as ScheduleEntity;
      final participantList = await _getParticipantList(selectScheduleId);
      final participantItemModels = participantList
          .map((userEntity) =>
              ParticipantItemModel.from(userEntity, selectScheduleEntity))
          .toList();
      _participants.clear();
      _participants.addAll(participantItemModels);
      participantsSink.add(_participants);
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
      if (_participantsStreamController.isClosed || lastSnapshot == null) {
        status = Status.none;
        notifyListeners();
        return;
      }
      final selectScheduleId = await _getSelectScheduleId();
      final selectScheduleEntity = (await fromCancelable(
              _scheduleRepositoryImpl.fetchSchedule(selectScheduleId)))
          as ScheduleEntity;
      final participantList = await _getParticipantList(selectScheduleId);
      final participantItemModels = participantList
          .map((userEntity) =>
              ParticipantItemModel.from(userEntity, selectScheduleEntity))
          .toList();
      _participants.addAll(participantItemModels);
      participantsSink.add(_participants);
      status = Status.success;
      debugPrint('追加読み込み, ${participantList.length}');
    } on NoSelectScheduleException {
      participantsSink.addError(NoSelectScheduleException());
      status = Status.none;
    } on ParticipantsEmptyException {
      // 追加読み込むするデータが空の場合なので、ストリームにエラーは流さない
      lastSnapshot = null;
      status = Status.none;
    }
    notifyListeners();
  }

  Future<String> _getSelectScheduleId() async {
    final user =
        (await fromCancelable(_userRepositoryImpl.fetchUser())) as UserEntity;
    if (user.selectScheduleId.isEmpty) {
      throw NoSelectScheduleException();
    }
    return user.selectScheduleId;
  }

  Future<List<UserEntity>> _getParticipantList(String selectScheduleId) async {
    List<DocumentSnapshot> participantDocuments;
    if (lastSnapshot == null) {
      participantDocuments = (await fromCancelable(_scheduleRepositoryImpl
              .fetchParticipantsAtStart(selectScheduleId)))
          as List<DocumentSnapshot>;
    } else {
      participantDocuments = (await fromCancelable(_scheduleRepositoryImpl
              .fetchParticipantsNext(selectScheduleId, lastSnapshot)))
          as List<DocumentSnapshot>;
    }
    if (participantDocuments == null || participantDocuments.isEmpty) {
      throw ParticipantsEmptyException();
    }
    lastSnapshot = participantDocuments.last;
    return participantDocuments
        .map((doc) => UserEntity.fromMap(doc.data))
        .toList();
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
