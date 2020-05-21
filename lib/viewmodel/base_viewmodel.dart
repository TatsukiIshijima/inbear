import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';

class BaseViewModel extends ChangeNotifier {
  CancelableOperation _cancelableOperation;

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

  @override
  void dispose() {
    _cancelableOperation?.cancel();
    super.dispose();
  }
}
