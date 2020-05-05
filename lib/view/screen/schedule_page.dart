import 'package:flutter/cupertino.dart';
import 'package:inbear_app/localize/app_localizations.dart';

class SchedulePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SchedulePageContent();
  }

}

class SchedulePageContent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var resource = AppLocalizations.of(context);
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(resource.scheduleGroomNameLabelText),
              Text(resource.scheduleBrideNameLabelText),
              Text(resource.scheduleDateLabelText),
              Text(resource.schedulePlaceLabelText)
            ],
          ),
        )
      ],
    );
  }

}