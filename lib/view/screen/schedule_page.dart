import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/schedule_respository.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/status.dart';
import 'package:inbear_app/view/screen/base_page.dart';
import 'package:inbear_app/view/widget/centering_error_message.dart';
import 'package:inbear_app/view/widget/label.dart';
import 'package:inbear_app/view/widget/reload_button.dart';
import 'package:inbear_app/viewmodel/home_viewmodel.dart';
import 'package:inbear_app/viewmodel/schedule_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../routes.dart';

class SchedulePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SchedulePageState();
}

class SchedulePageState extends State<SchedulePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BasePage<ScheduleViewModel>(
      viewModel: ScheduleViewModel(
          Provider.of<UserRepository>(context, listen: false),
          Provider.of<ScheduleRepository>(context, listen: false)),
      child: Scaffold(
        body: Stack(
          children: <Widget>[SchedulePageBody(), ScheduleChangeReceiver()],
        ),
        floatingActionButton: FloatingActionButtons(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SchedulePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    final viewModel = Provider.of<ScheduleViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await viewModel.executeFetchSelectSchedule();
      await viewModel.checkScheduleOwner();
    });
    return Selector<ScheduleViewModel, Status>(
      selector: (context, viewModel) => viewModel.status,
      builder: (context, status, child) {
        switch (status) {
          case Status.unLoginError:
            return CenteringErrorMessage(resource,
                message: resource.unloginError);
          case Status.userDocumentNotExistError:
            return CenteringErrorMessage(resource,
                message: resource.notExistUserDataError);
          case Status.scheduleDocumentNotExistError:
            return CenteringErrorMessage(resource,
                message: resource.notExistScheduleDataError);
          case ScheduleStatus.noSelectScheduleError:
            return CenteringErrorMessage(resource,
                message: resource.noSelectScheduleError);
          case Status.timeoutError:
            return ReloadButton(onPressed: () async {
              await viewModel.executeFetchSelectSchedule();
            });
          case ScheduleStatus.fetchSelectScheduleSuccess:
            return ScheduleDetail();
          default:
            return Container();
        }
      },
    );
  }
}

class ScheduleDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    final viewModel = Provider.of<ScheduleViewModel>(context, listen: false);
    return SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.all(24),
            child: Selector<ScheduleViewModel, ScheduleEntity>(
              selector: (context, viewModel) => viewModel.schedule,
              builder: (context, schedule, child) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Label(
                    text: resource.scheduleGroomText,
                    iconData: Icons.account_circle,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      schedule.groom,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Label(
                      text: resource.scheduleBrideText,
                      iconData: Icons.account_circle),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      schedule.bride,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Label(
                      text: resource.scheduleDateLabelText,
                      iconData: Icons.calendar_today),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      viewModel.dateToString(schedule.dateTime),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Label(
                    text: resource.schedulePlaceLabelText,
                    iconData: Icons.place,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      schedule.address,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * (3 / 4),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(schedule.geoPoint.latitude,
                            schedule.geoPoint.longitude),
                        zoom: 17.0,
                      ),
                      markers: {
                        Marker(
                            markerId: MarkerId('markerPoint'),
                            position: LatLng(schedule.geoPoint.latitude,
                                schedule.geoPoint.longitude))
                      },
                      mapType: MapType.normal,
                      myLocationButtonEnabled: false,
                    ),
                  )
                ],
              ),
            )));
  }
}

class FloatingActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ScheduleViewModel>(context, listen: false);
    return Selector<ScheduleViewModel, bool>(
      selector: (context, viewModel) => viewModel.isOwnerSchedule,
      builder: (context, isOwner, child) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (isOwner)
            Container(
              margin: EdgeInsets.only(bottom: 16.0),
              child: FloatingActionButton(
                heroTag: 'EditSchedule',
                onPressed: () async {
                  if (viewModel.schedule != null) {
                    final isUpdate = await Routes.goToScheduleEdit(
                        context, viewModel.schedule);
                    if (isUpdate != null && isUpdate) {
                      await viewModel.executeFetchSelectSchedule();
                    }
                  }
                },
                child: const Icon(Icons.edit),
              ),
            ),
          FloatingActionButton(
            heroTag: 'AddSchedule',
            onPressed: () => Routes.goToScheduleRegister(context),
            child: const Icon(Icons.add),
          )
        ],
      ),
    );
  }
}

class ScheduleChangeReceiver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ScheduleViewModel>(context, listen: false);
    return Selector<HomeViewModel, bool>(
      selector: (context, viewModel) => viewModel.isSelectScheduleChanged,
      builder: (context, isSelectScheduleChanged, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await viewModel.executeFetchSelectSchedule();
          await viewModel.checkScheduleOwner();
          debugPrint('スケジュール切り替えました : $isSelectScheduleChanged}');
        });
        return Container();
      },
    );
  }
}
