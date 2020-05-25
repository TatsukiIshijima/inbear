import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/localize/app_localizations.dart';

class CenteringErrorMessage extends StatelessWidget {
  final Object exception;
  final AppLocalizations resource;
  final String message;

  CenteringErrorMessage(this.resource, {this.exception, this.message = ''});

  @override
  Widget build(BuildContext context) {
    var errorMessage = resource.generalError;
    if (message.isNotEmpty) {
      errorMessage = message;
    } else {
      if (exception is UnLoginException) {
        errorMessage = resource.unloginError;
      } else if (exception is UserDocumentNotExistException) {
        errorMessage = resource.notExistUserDataError;
      } else if (exception is NoSelectScheduleException) {
        errorMessage = resource.noSelectScheduleError;
      } else if (exception is NotRegisterAnyImagesException) {
        errorMessage = resource.albumNotRegisterMessage;
      } else if (exception is ParticipantsEmptyException) {
        errorMessage = resource.participantsEmptyErrorMessage;
      } else if (exception is SearchUsersEmptyException) {
        errorMessage = resource.notFoundEmailAddressUserMessage;
      } else if (exception is TimeoutException) {
        errorMessage = resource.timeoutError;
      }
    }
    return Center(
      child: Text(
        errorMessage,
        textAlign: TextAlign.center,
      ),
    );
  }
}
