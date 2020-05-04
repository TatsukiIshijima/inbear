import 'package:inbear_app/localize/app_localizations.dart';

enum ScheduleRegisterStatus {
  None,
  Loading,
  Success,
  UnSelectDateError,
  InvalidPostalCodeError,
  UnableSearchAddressError,
  Timeout,
  HttpError,
  SocketError,
  UnLoginError,
  GeneralError,
}

extension ScheduleRegisterStatusExtension on ScheduleRegisterStatus {
  static Map toTitleAndMessage(AppLocalizations resource, ScheduleRegisterStatus status) {
    var titleAndMessage = {
      'title': '',
      'message': ''
    };
    switch (status) {
      case ScheduleRegisterStatus.None:
        break;
      case ScheduleRegisterStatus.Loading:
        break;
      case ScheduleRegisterStatus.Success:
        break;
      case ScheduleRegisterStatus.UnSelectDateError:
        titleAndMessage['title'] = resource.generalErrorTitle;
        titleAndMessage['message'] = resource.unselectDateError;
        break;
      case ScheduleRegisterStatus.InvalidPostalCodeError:
        titleAndMessage['title'] = resource.generalErrorTitle;
        titleAndMessage['message'] = resource.invalidPostalCodeError;
        break;
      case ScheduleRegisterStatus.UnableSearchAddressError:
        titleAndMessage['title'] = resource.generalErrorTitle;
        titleAndMessage['message'] = resource.unableSearchAddressError;
        break;
      case ScheduleRegisterStatus.Timeout:
        titleAndMessage['title'] = resource.connectionErrorTitle;
        titleAndMessage['message'] = resource.timeoutError;
        break;
      case ScheduleRegisterStatus.HttpError:
        titleAndMessage['title'] = resource.connectionErrorTitle;
        titleAndMessage['message'] = resource.httpError;
        break;
      case ScheduleRegisterStatus.SocketError:
        titleAndMessage['title'] = resource.connectionErrorTitle;
        titleAndMessage['message'] = resource.socketError;
        break;
      case ScheduleRegisterStatus.UnLoginError:
        titleAndMessage['title'] = resource.generalErrorTitle;
        titleAndMessage['message'] = resource.unloginError;
        break;
      case ScheduleRegisterStatus.GeneralError:
        titleAndMessage['title'] = resource.generalErrorTitle;
        titleAndMessage['message'] = resource.generalError;
        break;
    }
    return titleAndMessage;
  }
}