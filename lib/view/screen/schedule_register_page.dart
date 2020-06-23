import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/address_repository.dart';
import 'package:inbear_app/repository/schedule_respository.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/status.dart';
import 'package:inbear_app/view/screen/base_page.dart';
import 'package:inbear_app/view/widget/default_dialog.dart';
import 'package:inbear_app/view/widget/input_field.dart';
import 'package:inbear_app/view/widget/label.dart';
import 'package:inbear_app/view/widget/round_button.dart';
import 'package:inbear_app/viewmodel/schedule_register_viewmodel.dart';
import 'package:provider/provider.dart';

class ScheduleRegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    return BasePage<ScheduleRegisterViewModel>(
      viewModel: ScheduleRegisterViewModel(
          Provider.of<UserRepository>(context, listen: false),
          Provider.of<ScheduleRepository>(context, listen: false),
          Provider.of<AddressRepository>(context, listen: false)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            resource.scheduleRegisterTitle,
          ),
          centerTitle: true,
        ),
        body: ScheduleRegisterPageBody(),
      ),
    );
  }
}

class ScheduleRegisterPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: RegisterScheduleForm(),
          ),
          RegisterAlertDialog()
        ],
      ),
    );
  }
}

class RegisterScheduleForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _groomNameFocus = FocusNode();
  final _brideNameFocus = FocusNode();
  final _postalCodeFocus = FocusNode();
  final _addressFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    final viewModel =
        Provider.of<ScheduleRegisterViewModel>(context, listen: false);
    viewModel.setPostalCodeInputEvent();
    return Container(
      margin: EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Label(
              text: resource.scheduleNameLabelText,
              iconData: Icons.account_circle,
            ),
            const SizedBox(
              height: 12,
            ),
            InputField(
              resource.scheduleGroomNameLabelText,
              viewModel.groomTextEditingController,
              maxLength: 24,
              textInputType: TextInputType.text,
              validator: (text) => text.isEmpty ? resource.emptyError : null,
              focusNode: _groomNameFocus,
              onFieldSubmitted: (text) => _brideNameFocus.requestFocus(),
            ),
            const SizedBox(
              height: 24,
            ),
            InputField(
              resource.scheduleBrideNameLabelText,
              viewModel.brideTextEditingController,
              maxLength: 24,
              textInputType: TextInputType.text,
              validator: (text) => text.isEmpty ? resource.emptyError : null,
              focusNode: _brideNameFocus,
              onFieldSubmitted: (text) {},
            ),
            const SizedBox(
              height: 24,
            ),
            Label(
              text: resource.scheduleDateLabelText,
              iconData: Icons.calendar_today,
            ),
            const SizedBox(
              height: 12,
            ),
            RaisedButton(
              padding: EdgeInsets.all(20),
              child: Selector<ScheduleRegisterViewModel, DateTime>(
                selector: (context, viewModel) => viewModel.scheduledDateTime,
                builder: (context, dateTime, child) => Text(
                  dateTime == null
                      ? resource.scheduleDateSelectDescription
                      : viewModel.dateToString(dateTime),
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              color: Colors.grey[50],
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.grey)),
              elevation: 0,
              onPressed: () {
                DatePicker.showDateTimePicker(context, showTitleActions: true,
                    onConfirm: (date) {
                  viewModel.updateDate(date);
                  _postalCodeFocus.requestFocus();
                }, locale: LocaleType.jp, currentTime: DateTime.now());
              },
            ),
            const SizedBox(
              height: 24,
            ),
            Label(
              text: resource.schedulePlaceLabelText,
              iconData: Icons.place,
            ),
            const SizedBox(
              height: 12,
            ),
            Text(resource.schedulePostalCodeSearchDescription),
            const SizedBox(
              height: 12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: InputField(
                    resource.schedulePostalCodeLabelText,
                    viewModel.postalCodeTextEditingController,
                    maxLength: 7,
                    textInputType: TextInputType.number,
                    validator: (text) => null,
                    focusNode: _postalCodeFocus,
                  ),
                ),
                const SizedBox(
                  width: 1,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 60,
                    child: Selector<ScheduleRegisterViewModel, bool>(
                      selector: (context, viewModel) =>
                          viewModel.isPostalCodeFormat,
                      builder: (context, isPostalCodeFormat, child) =>
                          FlatButton(
                        shape: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(
                                color: isPostalCodeFormat
                                    ? Colors.pink[200]
                                    : Colors.grey)),
                        color: isPostalCodeFormat
                            ? Colors.pink[200]
                            : Colors.grey[400],
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          if (viewModel.validatePostalCode()) {
                            await viewModel.executeFetchAddress();
                            _addressFocus.requestFocus();
                          }
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Selector<ScheduleRegisterViewModel, TextEditingController>(
              selector: (context, viewModel) =>
                  viewModel.addressTextEditingController,
              builder: (context, textEditingController, child) => InputField(
                resource.scheduleAddressLabelText,
                textEditingController,
                maxLength: 100,
                textInputType: TextInputType.text,
                validator: (text) => text.isEmpty ? resource.emptyError : null,
                focusNode: _addressFocus,
                onFieldSubmitted: (text) async =>
                    await viewModel.executeConvertPostalCode(),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * (3 / 4),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(35.681236, 139.767125), zoom: 17.0),
                mapType: MapType.normal,
                myLocationButtonEnabled: false,
                onMapCreated: (mapController) =>
                    viewModel.mapCreated(mapController),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            RoundButton(
              text: resource.registerButtonTitle,
              minWidth: MediaQuery.of(context).size.width,
              backgroundColor: Colors.pink[200],
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  await viewModel.executeRegisterSchedule();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterAlertDialog extends StatelessWidget {
  void _showRegisterError(BuildContext context, String title, String message) {
    final resource = AppLocalizations.of(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showDialog<DefaultDialog>(
          context: context,
          builder: (context) => DefaultDialog(
                title,
                message,
                positiveButtonTitle: resource.defaultPositiveButtonTitle,
                onPositiveButtonPressed: () {},
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    return Selector<ScheduleRegisterViewModel, Status>(
      selector: (context, viewModel) => viewModel.status,
      builder: (context, status, child) {
        switch (status) {
          case ScheduleRegisterStatus.registerScheduleSuccess:
            WidgetsBinding.instance
                .addPostFrameCallback((_) => Navigator.pop(context, true));
            break;
          case ScheduleRegisterStatus.unSelectDateError:
            _showRegisterError(context, resource.inputFormErrorTitle,
                resource.unselectDateError);
            break;
          case ScheduleRegisterStatus.invalidPostalCodeError:
            _showRegisterError(context, resource.inputFormErrorTitle,
                resource.invalidPostalCodeError);
            break;
          case ScheduleRegisterStatus.unableSearchAddressError:
            _showRegisterError(context, resource.generalErrorTitle,
                resource.unableSearchAddressError);
            break;
          case ScheduleRegisterStatus.overDailyLimitError:
            _showRegisterError(context, resource.generalErrorTitle,
                resource.overDailyLimitError);
            break;
          case ScheduleRegisterStatus.requestDeniedError:
            _showRegisterError(context, resource.generalErrorTitle,
                resource.requestDeniedError);
            break;
          case ScheduleRegisterStatus.invalidRequestError:
            _showRegisterError(context, resource.generalErrorTitle,
                resource.invalidRequestError);
            break;
        }
        return Container();
      },
    );
  }
}
