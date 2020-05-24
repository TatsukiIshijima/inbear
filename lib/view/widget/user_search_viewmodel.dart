import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:inbear_app/entity/user_entity.dart';
import 'package:inbear_app/repository/schedule_repository_impl.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/viewmodel/base_viewmodel.dart';

import '../../custom_exceptions.dart';

class UserSearchViewModel extends BaseViewModel {
  final UserRepositoryImpl _userRepositoryImpl;
  final ScheduleRepositoryImpl _scheduleRepositoryImpl;

  UserSearchViewModel(this._userRepositoryImpl, this._scheduleRepositoryImpl);

  final _searchUsersStreamController = StreamController<List<UserEntity>>();

  Stream<List<UserEntity>> get searchUsersStream =>
      _searchUsersStreamController.stream;
  StreamSink<List<UserEntity>> get searchUsersSink =>
      _searchUsersStreamController.sink;

  final List<UserEntity> _searchUsers = <UserEntity>[];

  @override
  void dispose() {
    _searchUsersStreamController.close();
    searchUsersSink.close();
    super.dispose();
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
      final userSelf = await _userRepositoryImpl.fetchUser();
      // 既に参加済みの人は検索結果から除く
      final notParticipantUsers = <UserEntity>[];
      for (final userEntity in searchResult) {
        final isParticipant = await _scheduleRepositoryImpl.isParticipantUser(
            userSelf.selectScheduleId, userEntity.uid);
        if (!isParticipant) {
          notParticipantUsers.add(userEntity);
        }
      }
      if (_searchUsersStreamController.isClosed) {
        debugPrint('searchUser : searchUsersStreamController is closed.');
        return;
      }
      _searchUsers.clear();
      _searchUsers.addAll(notParticipantUsers);
      searchUsersSink.add(_searchUsers);
    } on UnLoginException {
      searchUsersSink.addError(UnLoginException());
    } on UserDocumentNotExistException {
      searchUsersSink.addError(UserDocumentNotExistException());
    } on SearchUsersEmptyException {
      searchUsersSink.addError(SearchUsersEmptyException());
    } on TimeoutException {
      searchUsersSink.addError(TimeoutException('search user time out.'));
    }
  }

  Future<void> addParticipant(String targetUid) async {
    await fromCancelable(_addParticipant(targetUid));
  }

  Future<void> _addParticipant(String targetUid) async {
    try {
      final userSelf = await _userRepositoryImpl.fetchUser();
      await _scheduleRepositoryImpl.addParticipant(
          userSelf.selectScheduleId, targetUid);
    } on UnLoginException {} on UserDocumentNotExistException {} on TimeoutException {}
  }
}
