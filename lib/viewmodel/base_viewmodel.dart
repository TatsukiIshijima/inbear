import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/custom_exceptions.dart';

import '../status.dart';

class BaseViewModel extends ChangeNotifier {
  CancelableOperation _cancelableOperation;

  String status = Status.none;

  Future<dynamic> fromCancelable(Future<dynamic> future,
      {FutureOr Function() onCancel}) async {
    await _cancelableOperation?.cancel();
    _cancelableOperation =
        CancelableOperation<dynamic>.fromFuture(future, onCancel: () {
      debugPrint('Operation Canceled.');
      if (onCancel != null) {
        onCancel();
      }
    });
    return _cancelableOperation.value;
  }

  Future<void> executeFutureOperation(Future<dynamic> Function() future) async {
    try {
      status = Status.loading;
      notifyListeners();
      // ステータス成功を返すのはfuture()内で行う
      // ここで success にしてしまうと、catch できない Exception でも成功してしまうため
      await future();
    } on UnLoginException {
      status = Status.unLoginError;
    } on UserDocumentNotExistException {
      status = Status.userDocumentNotExistError;
    } on ScheduleDocumentNotExistException {
      status = Status.scheduleDocumentNotExistError;
    } on TimeoutException {
      status = Status.timeoutError;
    } on HttpException {
      status = Status.httpError;
    } on SocketException {
      status = Status.socketError;
    } on NetworkRequestException {
      status = Status.networkError;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _cancelableOperation?.cancel();
    super.dispose();
  }
}
