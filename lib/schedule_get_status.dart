import 'package:inbear_app/localize/app_localizations.dart';

enum ScheduleGetStatus {
  None,
  Loading,
  Success,
  NotExistDocumentError,
  UnLoginError,
  GeneralError,
}

extension ScheduleGetStatusExtension on ScheduleGetStatus {
  static Map toTitleAndMessage(AppLocalizations resource, ScheduleGetStatus status) {
    var titleAndMessage = {
      'title': '',
      'message': ''
    };
    switch(status) {
      case ScheduleGetStatus.None:
        break;
      case ScheduleGetStatus.Loading:
        break;
      case ScheduleGetStatus.Success:
        break;
      case ScheduleGetStatus.NotExistDocumentError:
        titleAndMessage['title'] = resource.generalErrorTitle;
        titleAndMessage['message'] = resource.notExistDataError;
        break;
      case ScheduleGetStatus.UnLoginError:
        titleAndMessage['title'] = resource.generalErrorTitle;
        titleAndMessage['message'] = resource.unloginError;
        break;
      case ScheduleGetStatus.GeneralError:
        titleAndMessage['title'] = resource.generalErrorTitle;
        titleAndMessage['message'] = resource.generalError;
        break;
    }
  }
}