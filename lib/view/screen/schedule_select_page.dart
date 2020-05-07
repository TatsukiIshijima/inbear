import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/localize/app_localizations.dart';

class ScheduleSelectPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var resource = AppLocalizations.of(context);
    return Scaffold(
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
        child: ScheduleSelectContent(),
      ),
    );
  }

}

class ScheduleSelectContent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('ScheduleChangePage'),
    );
  }

}
