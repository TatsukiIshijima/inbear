import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/model/schedule.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/status.dart';
import 'package:inbear_app/view/widget/loading.dart';
import 'package:inbear_app/viewmodel/schedule_select_viewmodel.dart';
import 'package:provider/provider.dart';

class ScheduleSelectPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    return ChangeNotifierProvider(
      create: (context) => ScheduleSelectViewModel(
        Provider.of<UserRepository>(context, listen: false)
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(resource.scheduleRegisterTitle,
            style: TextStyle(
                color: Colors.white
            ),
          ),
          iconTheme: IconThemeData(
              color: Colors.white
          ),
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

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ScheduleSelectViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async =>
      await viewModel.fetchEntrySchedule()
    );
    return Selector<ScheduleSelectViewModel, String>(
      selector: (context, viewModel) => viewModel.status,
      builder: (context, status, child) {
        switch(status) {
          case Status.loading:
            return Center(
              child: Loading(),
            );
          case Status.success:
            return Selector<ScheduleSelectViewModel, List<Schedule>>(
              selector: (context, viewModel) => viewModel.schedules,
              builder: (context, schedules, child) =>
                  ListView.builder(
                      itemCount: schedules.length,
                      itemBuilder: (context, int index) =>
                          Text('${schedules[index].groom} & ${schedules[index].bride}')
                  ),
            );
          case Status.unLoginError:
            return Center(
              child: Text(resource.unloginError),
            );
          case Status.generalError:
            return Center(
              child: Text(resource.generalError),
            );
          default:
            return Container();
        }
      }
    );
  }
}
