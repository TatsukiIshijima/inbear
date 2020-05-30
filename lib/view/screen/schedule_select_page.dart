import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/model/schedule_select_item_model.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/status.dart';
import 'package:inbear_app/view/screen/base_page.dart';
import 'package:inbear_app/view/widget/closed_question_dialog.dart';
import 'package:inbear_app/view/widget/schedule_select_item.dart';
import 'package:inbear_app/viewmodel/schedule_select_viewmodel.dart';
import 'package:provider/provider.dart';

class ScheduleSelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    return BasePage<ScheduleSelectViewModel>(
      viewModel: ScheduleSelectViewModel(
          Provider.of<UserRepository>(context, listen: false)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            resource.scheduleSelectTitle,
          ),
        ),
        body: SafeArea(
          child: ScheduleSelectPageBody(),
        ),
      ),
    );
  }
}

class ScheduleSelectPageBody extends StatelessWidget {
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
            case Status.success:
              return ScheduleList();
          }
          return Container();
        });
  }
}

class ScheduleList extends StatelessWidget {
  void _showConfirmDialog(BuildContext context, AppLocalizations resource,
      Future<dynamic> Function() future) {
    showDialog<ClosedQuestionDialog>(
        context: context,
        builder: (context) => ClosedQuestionDialog(
            title: resource.scheduleSelectConfirmTitle,
            message: resource.scheduleSelectConfirmMessage,
            positiveButtonTitle: resource.defaultPositiveButtonTitle,
            negativeButtonTitle: resource.defaultNegativeButtonTitle,
            onPositiveButtonPressed: () async {
              Navigator.pop(context);
              await future();
            }));
  }

  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    final viewModel =
        Provider.of<ScheduleSelectViewModel>(context, listen: false);
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
                          _showConfirmDialog(
                              context,
                              resource,
                              () => viewModel
                                  .selectSchedule(schedules[index].id));
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
}
