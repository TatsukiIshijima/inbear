import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/schedule_respository.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/schedule_get_status.dart';
import 'package:inbear_app/view/widget/label.dart';
import 'package:inbear_app/view/widget/loading.dart';
import 'package:inbear_app/viewmodel/schedule_viewmodel.dart';
import 'package:provider/provider.dart';

class SchedulePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScheduleViewModel(
        Provider.of<UserRepository>(context, listen: false),
        Provider.of<ScheduleRepository>(context, listen: false)
      ),
      child: SchedulePageContent(),
    );
  }

}

class SchedulePageContent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<ScheduleViewModel>(context, listen: false);
    var resource = AppLocalizations.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async =>
        await viewModel.fetchSelectSchedule());
    return Selector<ScheduleViewModel, ScheduleGetStatus>(
      selector: (context, viewModel) => viewModel.status,
      builder: (context, status, child) {
        if (status == ScheduleGetStatus.None) {
          return Container();
        } else if (status == ScheduleGetStatus.Loading) {
          return Center(child: Loading());
        } else if (status == ScheduleGetStatus.Success) {
          return Selector<ScheduleViewModel, ScheduleEntity>(
            selector: (context, viewModel) => viewModel.schedule,
            builder: (context, schedule, child) =>
              SingleChildScrollView(
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
                          style: TextStyle(
                              fontSize: 18
                          ),
                        ),
                      ),
                      Label(
                        text: resource.scheduleBrideText,
                        iconData: Icons.account_circle
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          schedule.bride,
                          style: TextStyle(
                              fontSize: 18
                          ),
                        ),
                      ),
                      Label(
                        text: resource.scheduleDateLabelText,
                        iconData: Icons.calendar_today
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          viewModel.dateToString(schedule.dateTime),
                          style: TextStyle(
                            fontSize: 18
                          ),
                        ),
                      ),
                      Label(
                        text :resource.schedulePlaceLabelText,
                        iconData: Icons.place,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          schedule.address,
                          style: TextStyle(
                            fontSize: 18
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width * ( 3 / 4),
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                                schedule.geoPoint.latitude,
                                schedule.geoPoint.longitude
                            ),
                            zoom: 17.0,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId('markerPoint'),
                              position: LatLng(
                                schedule.geoPoint.latitude,
                                schedule.geoPoint.longitude
                              )
                            )
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
        } else {
          var titleAndMessage = ScheduleGetStatusExtension
              .toTitleAndMessage(resource, status);
          return Center(
            child: Text(
              titleAndMessage['messsage'],
              style: TextStyle(
                fontSize: 20
              ),
            ),
          );
        }
      },
    );
  }

}