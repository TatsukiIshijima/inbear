import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/model/schedule_select_item_model.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/status.dart';
import 'package:inbear_app/view/widget/closed_question_dialog.dart';
import 'package:inbear_app/view/widget/loading.dart';
import 'package:inbear_app/view/widget/schedule_select_item.dart';
import 'package:inbear_app/viewmodel/schedule_select_viewmodel.dart';
import 'package:provider/provider.dart';

class ScheduleSelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    return ChangeNotifierProvider(
      create: (context) => ScheduleSelectViewModel(
          Provider.of<UserRepository>(context, listen: false)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            resource.scheduleSelectTitle,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child: ScheduleSelectContent(resource),
        ),
      ),
    );
  }
}

class ScheduleSelectContent extends StatelessWidget {
  final AppLocalizations resource;

  ScheduleSelectContent(this.resource);

  // FIXME:引数にViewModelではなくFuture<dynamic>みたいな感じで指定できるように
  void _showConfirmDialog(BuildContext context, AppLocalizations resource,
      ScheduleSelectViewModel viewModel, String selectScheduleId) {
    showDialog<ClosedQuestionDialog>(
        context: context,
        builder: (context) => ClosedQuestionDialog(
            title: resource.scheduleSelectConfirmTitle,
            message: resource.scheduleSelectConfirmMessage,
            positiveButtonTitle: resource.defaultPositiveButtonTitle,
            negativeButtonTitle: resource.defaultNegativeButtonTitle,
            onPositiveButtonPressed: () async {
              Navigator.pop(context);
              await viewModel.selectSchedule(selectScheduleId);
            }));
  }

  // FIXME:引数にViewModelではなくFuture<dynamic>みたいな感じで指定できるように
  Widget _scheduleList(ScheduleSelectViewModel viewModel) {
    return Selector<ScheduleSelectViewModel, List<ScheduleSelectItemModel>>(
        selector: (context, viewModel) => viewModel.scheduleItems,
        builder: (context, schedules, child) {
          if (schedules.isNotEmpty) {
            return ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (context, index) => ScheduleSelectItem(
                      pairName: schedules[index].pairName,
                      isSelect: schedules[index].isSelected,
                      onTap: () {
                        if (!schedules[index].isSelected) {
                          _showConfirmDialog(context, resource, viewModel,
                              schedules[index].id);
                        }
                      },
                    ));
          } else {
            return Center(
              child: Text(resource.notExistEntryScheduleError),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<ScheduleSelectViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await viewModel.fetchEntrySchedule();
    });
    return Selector<ScheduleSelectViewModel, String>(
        selector: (context, viewModel) => viewModel.status,
        builder: (context, status, child) {
          switch (status) {
            case Status.loading:
              return Center(
                child: Loading(),
              );
            case Status.success:
              return _scheduleList(viewModel);
            case Status.unLoginError:
              return Center(
                child: Text(resource.unloginError),
              );
            case Status.timeoutError:
              return Center(
                child: Text(resource.timeoutError),
              );
            default:
              return Container();
          }
        });
  }
}
