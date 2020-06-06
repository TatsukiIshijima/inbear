import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/exception/api/api_exception.dart';
import 'package:inbear_app/exception/auth/auth_exception.dart';
import 'package:inbear_app/exception/common_exception.dart';

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
    return await _cancelableOperation.value;
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
    } on ApiException catch (error) {
      switch (error.code) {
        case 400:
          status = Status.badRequestError;
          break;
        case 404:
          status = Status.notFoundError;
          break;
        case 405:
          status = Status.methodNotAllowError;
          break;
        case 408:
          status = Status.timeoutError;
          break;
        case 429:
          status = Status.tooManyRequestsError;
          break;
        default:
          status = Status.httpError;
          break;
      }
    } on InternalServerException {
      status = Status.internalServerError;
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
