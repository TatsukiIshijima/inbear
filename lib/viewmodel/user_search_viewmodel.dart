import 'dart:async';

import 'package:inbear_app/entity/user_entity.dart';
import 'package:inbear_app/repository/schedule_repository_impl.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/viewmodel/base_viewmodel.dart';

import '../exception/common_exception.dart';
import '../status.dart';

class UserSearchStatus extends Status {
  // ParticipantListPageのViewModelが破棄されないため、Status.successを呼ぶと
  // 二重で処理が実行されてしまうため、成功のステータスは分けておく
  static const searchSuccess = 'SearchSuccess';
  static const addSuccess = 'AddSuccess';
}

class UserSearchViewModel extends BaseViewModel {
  final UserRepositoryImpl _userRepositoryImpl;
  final ScheduleRepositoryImpl _scheduleRepositoryImpl;

  UserSearchViewModel(this._userRepositoryImpl, this._scheduleRepositoryImpl);

  final _searchUsersStreamController = StreamController<List<UserEntity>>();
  final List<UserEntity> _searchUsers = <UserEntity>[];

  Stream<List<UserEntity>> get searchUsersStream =>
      _searchUsersStreamController.stream;
  StreamSink<List<UserEntity>> get searchUsersSink =>
      _searchUsersStreamController.sink;

  @override
  void dispose() {
    _searchUsersStreamController.close();
    searchUsersSink.close();
    super.dispose();
  }

  Future<void> executeSearchUser(String email) async {
    await executeFutureOperation(() => _searchUser(email));
  }

  Future<void> _searchUser(String email) async {
    if (_searchUsersStreamController.isClosed) {
      status = Status.none;
      notifyListeners();
      return;
    }
    final searchResult =
        (await fromCancelable(_userRepositoryImpl.searchUser(email)))
            as List<UserEntity>;
    if (searchResult.isEmpty) {
      searchUsersSink.addError(SearchUsersEmptyException());
      status = Status.none;
      notifyListeners();
      return;
    }
    final userSelf =
        (await fromCancelable(_userRepositoryImpl.fetchUser())) as UserEntity;
    // 既に参加済みの人は検索結果から除く
    final notParticipantUsers = <UserEntity>[];
    for (final userEntity in searchResult) {
      final isParticipant = (await fromCancelable(_scheduleRepositoryImpl
              .isParticipantUser(userSelf.selectScheduleId, userEntity.uid)))
          as bool;
      if (!isParticipant) {
        notParticipantUsers.add(userEntity);
      }
    }
    _searchUsers.clear();
    _searchUsers.addAll(notParticipantUsers);
    searchUsersSink.add(_searchUsers);
    status = UserSearchStatus.searchSuccess;
    notifyListeners();
  }

  Future<void> executeAddParticipant(String targetUid) async {
    await executeFutureOperation(() => _addParticipant(targetUid));
  }

  Future<void> _addParticipant(String targetUid) async {
    final userSelf =
        (await fromCancelable(_userRepositoryImpl.fetchUser())) as UserEntity;
    await fromCancelable(_scheduleRepositoryImpl.addParticipant(
        userSelf.selectScheduleId, targetUid));
    await fromCancelable(_userRepositoryImpl.addScheduleInUser(
        targetUid, userSelf.selectScheduleId));
    status = UserSearchStatus.addSuccess;
    notifyListeners();
  }

  void searchResultClear() {
    _searchUsers.clear();
    searchUsersSink.add(_searchUsers);
  }
}
