import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/schedule_respository.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/status.dart';
import 'package:inbear_app/view/widget/label.dart';
import 'package:inbear_app/view/widget/loading.dart';
import 'package:inbear_app/viewmodel/schedule_viewmodel.dart';
import 'package:provider/provider.dart';

class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    return ChangeNotifierProvider(
      create: (context) => ScheduleViewModel(
          Provider.of<UserRepository>(context, listen: false),
          Provider.of<ScheduleRepository>(context, listen: false)),
      child: SchedulePageContent(resource),
    );
  }
}

class SchedulePageContent extends StatelessWidget {
  final AppLocalizations resource;

  SchedulePageContent(this.resource);

  Widget _scheduleContent(
      AppLocalizations resource, ScheduleViewModel viewModel) {
    return Selector<ScheduleViewModel, ScheduleEntity>(
      selector: (context, viewModel) => viewModel.schedule,
      builder: (context, schedule, child) => SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Column(
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
        ),
      ),
    );
  }

  Widget _errorMessage(String errorMessage) {
    return Center(
      child: Text(
        errorMessage,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _reloadWidget(BuildContext context, Future<void> fun) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            resource.timeoutError,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            onPressed: () async => await fun,
            child: Text(
              resource.reloadMessage,
              style: TextStyle(color: Color(0xfff48fb1)),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                side: BorderSide(color: Color(0xfff48fb1))),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ScheduleViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async =>
        await viewModel.fromCancelable(viewModel.fetchSelectSchedule()));
    return Selector<ScheduleViewModel, String>(
      selector: (context, viewModel) => viewModel.status,
      builder: (context, status, child) {
        switch (status) {
          case Status.loading:
            return Center(child: Loading());
          case Status.unLoginError:
            return _errorMessage(resource.unloginError);
          case ScheduleGetStatus.notExistUserDataError:
            return _errorMessage(resource.notExistUserDataError);
          case ScheduleGetStatus.notExistScheduleDataError:
            return _errorMessage(resource.notExistScheduleDataError);
          case ScheduleGetStatus.noSelectScheduleError:
            return _errorMessage(resource.noSelectScheduleError);
          case Status.timeoutError:
            return _reloadWidget(context, viewModel.fetchSelectSchedule());
          case Status.success:
            return _scheduleContent(resource, viewModel);
          default:
            return Container();
        }
      },
    );
  }
}
