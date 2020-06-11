import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/view/widget/default_dialog.dart';
import 'package:inbear_app/view/widget/loading.dart';
import 'package:inbear_app/viewmodel/base_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../status.dart';

class BasePage<T extends BaseViewModel> extends StatelessWidget {
  final T viewModel;
  final Widget child;

  BasePage({@required this.viewModel, @required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Stack(
        children: <Widget>[child, OverlayLoading<T>()],
      ),
    );
  }
}

class OverlayLoading<T extends BaseViewModel> extends StatelessWidget {
  void _showErrorDialog(
    BuildContext context,
    String message,
  ) {
    final resource = AppLocalizations.of(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showDialog<DefaultDialog>(
          context: context,
          builder: (context) => DefaultDialog(
                resource.generalErrorTitle,
                message,
                positiveButtonTitle: resource.defaultPositiveButtonTitle,
                onPositiveButtonPressed: () {},
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    return Selector<T, Status>(
      selector: (context, viewModel) => viewModel.status,
      builder: (context, status, child) {
        debugPrint('Status<${T.toString()}>: $status');
        switch (status) {
          case Status.loading:
            return Container(
              decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.3)),
              child: Center(
                child: Loading(),
              ),
            );
          case Status.unLoginError:
            _showErrorDialog(context, resource.unloginError);
            break;
          case Status.userDocumentNotExistError:
            _showErrorDialog(context, resource.notExistUserDataError);
            break;
          case Status.scheduleDocumentNotExistError:
            _showErrorDialog(context, resource.notExistScheduleDataError);
            break;
          case Status.timeoutError:
            _showErrorDialog(context, resource.timeoutError);
            break;
          case Status.badRequestError:
            _showErrorDialog(context, resource.badRequestError);
            break;
          case Status.notFoundError:
            _showErrorDialog(context, resource.notFoundError);
            break;
          case Status.methodNotAllowError:
            _showErrorDialog(context, resource.methodNotAllowError);
            break;
          case Status.tooManyRequestsError:
            _showErrorDialog(context, resource.tooManyRequestsError);
            break;
          case Status.httpError:
            _showErrorDialog(context, resource.httpError);
            break;
          case Status.socketError:
            _showErrorDialog(context, resource.socketError);
            break;
          case Status.networkError:
            _showErrorDialog(context, resource.networkError);
            break;
        }
        return Container();
      },
    );
  }
}
