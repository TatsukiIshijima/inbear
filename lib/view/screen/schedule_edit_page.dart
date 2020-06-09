import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inbear_app/entity/schedule_entity.dart';
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
import 'package:inbear_app/viewmodel/schedule_edit_viewmodel.dart';
import 'package:inbear_app/viewmodel/schedule_register_viewmodel.dart';
import 'package:provider/provider.dart';

class ScheduleEditPage extends StatelessWidget {
  final ScheduleEntity scheduleEntity;

  ScheduleEditPage(this.scheduleEntity);

  @override
  Widget build(BuildContext context) {
    return BasePage<ScheduleEditViewModel>(
      viewModel: ScheduleEditViewModel(
          Provider.of<UserRepository>(context, listen: false),
          Provider.of<ScheduleRepository>(context, listen: false),
          Provider.of<AddressRepository>(context, listen: false),
          scheduleEntity),
      child: Scaffold(
        appBar: AppBar(
          title: Text('スケジュール編集'),
          centerTitle: true,
        ),
        body: ScheduleEditBody(),
      ),
    );
  }
}

class ScheduleEditBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: ScheduleEditForm(),
          ),
          UpdateScheduleAlertDialog(),
        ],
      ),
    );
  }
}

class ScheduleEditForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _groomNameFocus = FocusNode();
  final _brideNameFocus = FocusNode();
  final _postalCodeFocus = FocusNode();
  final _addressFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    final viewModel =
        Provider.of<ScheduleEditViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      viewModel.initForm();
      viewModel.setPostalCodeInputEvent();
    });
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
              child: Selector<ScheduleEditViewModel, DateTime>(
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
                    child: Selector<ScheduleEditViewModel, bool>(
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
            Selector<ScheduleEditViewModel, TextEditingController>(
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
                    target: LatLng(viewModel.scheduleEntity.geoPoint.latitude,
                        viewModel.scheduleEntity.geoPoint.longitude),
                    zoom: 17.0),
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
                  await viewModel.executeUpdateSchedule();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateScheduleAlertDialog extends StatelessWidget {
  void _showUpdateError(BuildContext context, String title, String message) {
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
    return Selector<ScheduleEditViewModel, Status>(
      selector: (context, viewModel) => viewModel.status,
      builder: (context, status, child) {
        switch (status) {
          case ScheduleEditStatus.updateScheduleSuccess:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context, true);
            });
            break;
          case ScheduleRegisterStatus.unSelectDateError:
            _showUpdateError(context, resource.inputFormErrorTitle,
                resource.unselectDateError);
            break;
          case ScheduleRegisterStatus.invalidPostalCodeError:
            _showUpdateError(context, resource.inputFormErrorTitle,
                resource.invalidPostalCodeError);
            break;
          case ScheduleRegisterStatus.unableSearchAddressError:
            _showUpdateError(context, resource.generalErrorTitle,
                resource.unableSearchAddressError);
            break;
          case ScheduleRegisterStatus.overDailyLimitError:
            _showUpdateError(context, resource.generalErrorTitle,
                resource.overDailyLimitError);
            break;
          case ScheduleRegisterStatus.requestDeniedError:
            _showUpdateError(context, resource.generalErrorTitle,
                resource.requestDeniedError);
            break;
          case ScheduleRegisterStatus.invalidRequestError:
            _showUpdateError(context, resource.generalErrorTitle,
                resource.invalidRequestError);
            break;
        }
        return Container();
      },
    );
  }
}
