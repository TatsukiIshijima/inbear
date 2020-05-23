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

  final _searchUsersStreamController = StreamController<List<UserEntity>>();
  final _participantsStreamController = StreamController<List<UserEntity>>();
  final List<UserEntity> _searchUsers = <UserEntity>[];
  //final List<UserEntity> _participants = <UserEntity>[];
  final scrollController = ScrollController();

  Stream<List<UserEntity>> get searchUsersStream =>
      _searchUsersStreamController.stream;
  StreamSink<List<UserEntity>> get searchUsersSink =>
      _searchUsersStreamController.sink;

  Stream<List<UserEntity>> get participantsStream =>
      _participantsStreamController.stream;
  StreamSink<List<UserEntity>> get participantsSink =>
      _participantsStreamController.sink;

  @override
  void dispose() {
    _searchUsersStreamController.close();
    _participantsStreamController.close();
    searchUsersSink.close();
    participantsSink.close();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchParticipants() async {
    debugPrint('fetchParticipants');
  }

  Future<void> searchUser(String email) async {
    await fromCancelable(_searchUser(email));
  }

  Future<void> _searchUser(String email) async {
    try {
      final searchResult = await _userRepositoryImpl.searchUser(email);
      if (searchResult.isEmpty) {
        throw SearchUsersEmptyException();
      }
      _searchUsers.clear();
      _searchUsers.addAll(searchResult);
      searchUsersSink.add(_searchUsers);
    } on SearchUsersEmptyException {
      searchUsersSink.addError(SearchUsersEmptyException());
    } on TimeoutException {
      searchUsersSink.addError(TimeoutException('search user time out.'));
    }
  }
}
