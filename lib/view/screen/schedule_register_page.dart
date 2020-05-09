import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/address_repository.dart';
import 'package:inbear_app/repository/schedule_respository.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/status.dart';
import 'package:inbear_app/view/widget/input_field.dart';
import 'package:inbear_app/view/widget/label.dart';
import 'package:inbear_app/view/widget/loading.dart';
import 'package:inbear_app/view/widget/round_button.dart';
import 'package:inbear_app/view/widget/single_button_dialog.dart';
import 'package:inbear_app/viewmodel/schedule_register_viewmodel.dart';
import 'package:provider/provider.dart';

class ScheduleRegisterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    return ChangeNotifierProvider(
      create: (context) => ScheduleRegisterViewModel(
        Provider.of<UserRepository>(context, listen: false),
        Provider.of<ScheduleRepository>(context, listen: false),
        Provider.of<AddressRepository>(context, listen: false)
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
          child: ScheduleRegisterContent(resource),
        ),
      ),
    );
  }

}

class ScheduleRegisterContent extends StatelessWidget {

  final AppLocalizations resource;

  ScheduleRegisterContent(this.resource);

  final _formKey = GlobalKey<FormState>();
  final _groomNameFocus = FocusNode();
  final _brideNameFocus = FocusNode();
  final _postalCodeFocus = FocusNode();
  final _addressFocus = FocusNode();

  Widget _formContent(BuildContext context, ScheduleRegisterViewModel viewModel) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Label(
                text: resource.scheduleNameLabelText,
                iconData: Icons.account_circle,
              ),
              SizedBox(height: 12,),
              InputField(
                labelText: resource.scheduleGroomNameLabelText,
                textInputType: TextInputType.text,
                textEditingController: viewModel.groomTextEditingController,
                validator: (text) => text.isEmpty ? resource.emptyError : null,
                focusNode: _groomNameFocus,
                onFieldSubmitted: (text) => _brideNameFocus.requestFocus(),
              ),
              SizedBox(height: 24,),
              InputField(
                labelText: resource.scheduleBrideNameLabelText,
                textInputType: TextInputType.text,
                textEditingController: viewModel.brideTextEditingController,
                validator: (text) => text.isEmpty ? resource.emptyError : null,
                focusNode: _brideNameFocus,
                onFieldSubmitted: (text) {},
              ),
              SizedBox(height: 24,),
              Label(
                text: resource.scheduleDateLabelText,
                iconData: Icons.calendar_today,
              ),
              SizedBox(height: 12,),
              RaisedButton(
                padding: EdgeInsets.all(20),
                child: Selector<ScheduleRegisterViewModel, DateTime>(
                  selector: (context, viewModel) => viewModel.scheduledDateTime,
                  builder: (context, dateTime, child) =>
                      Text(
                        dateTime == null ?
                        resource.scheduleDateSelectDescription :
                        viewModel.dateToString(dateTime),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                ),
                color: Colors.grey[50],
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(
                        color: Colors.grey
                    )
                ),
                elevation: 0,
                onPressed: () {
                  DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      onConfirm: (date) {
                        viewModel.updateDate(date);
                        _postalCodeFocus.requestFocus();
                      } ,
                      locale: LocaleType.jp,
                      currentTime: DateTime.now()
                  );
                },
              ),
              SizedBox(height: 24,),
              Label(
                text: resource.schedulePlaceLabelText,
                iconData: Icons.place,
              ),
              SizedBox(height: 12,),
              Text(resource.schedulePostalCodeSearchDescription),
              SizedBox(height: 12,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: InputField(
                      labelText: resource.schedulePostalCodeLabelText,
                      textInputType: TextInputType.number,
                      textEditingController: viewModel.postalCodeTextEditingController,
                      validator: (text) => null,
                      focusNode: _postalCodeFocus,
                    ),
                  ),
                  SizedBox(width: 1,),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 60,
                      child: Selector<ScheduleRegisterViewModel, bool>(
                        selector: (context, viewModel) => viewModel.isPostalCodeFormat,
                        builder: (context, isPostalCodeFormat, child) =>
                            FlatButton(
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(color: isPostalCodeFormat ? Colors.pink[200] : Colors.grey)
                              ),
                              color: isPostalCodeFormat ? Colors.pink[200] : Colors.grey[400],
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                if (viewModel.validatePostalCode()) {
                                  await viewModel.fetchAddress();
                                  _addressFocus.requestFocus();
                                }
                              },
                            ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 24,),
              Selector<ScheduleRegisterViewModel, TextEditingController>(
                selector: (context, viewModel) => viewModel.addressTextEditingController,
                builder: (context, textEditingController, child) => InputField(
                  labelText: resource.scheduleAddressLabelText,
                  textInputType: TextInputType.text,
                  textEditingController: textEditingController,
                  validator: (text) => text.isEmpty ? resource.emptyError : null,
                  focusNode: _addressFocus,
                  onFieldSubmitted: (text) async => await viewModel.convertPostalCodeToLocation(),
                ),
              ),
              SizedBox(height: 24,),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * ( 3 / 4),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(35.681236, 139.767125),
                      zoom: 17.0
                  ),
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  onMapCreated: (mapController) => viewModel.mapCreated(mapController),
                ),
              ),
              SizedBox(height: 24,),
              RoundButton(
                text: resource.registerButtonTitle,
                minWidth: MediaQuery.of(context).size.width,
                backgroundColor: Colors.pink[200],
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    await viewModel.registerSchedule();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(
      BuildContext context,
      String title,
      String message) {
    showDialog(
      context: context,
      builder: (context) =>
        SingleButtonDialog(
          title: title,
          message: message,
          positiveButtonTitle: resource.defaultPositiveButtonTitle,
          onPressed: () => Navigator.pop(context),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ScheduleRegisterViewModel>(context, listen: false);
    viewModel.setPostalCodeInputEvent();
    return Stack(
      children: <Widget>[
        _formContent(context, viewModel),
        // Loading or Alert
        Selector<ScheduleRegisterViewModel, String>(
          selector: (context, viewModel) => viewModel.status,
          builder: (context, status, child) {
            switch (status) {
              case Status.loading:
                return Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.3)
                  ),
                  child: Center(
                    child: Loading(),
                  ),
                );
              case Status.success:
                WidgetsBinding.instance.addPostFrameCallback((_) =>
                    Navigator.pop(context));
                return Container();
              case ScheduleRegisterStatus.unSelectDateError:
                WidgetsBinding.instance.addPostFrameCallback((_) =>
                    _showErrorDialog(
                        context,
                        resource.inputFormErrorTitle,
                        resource.unselectDateError
                    ));
                return Container();
              case ScheduleRegisterStatus.invalidPostalCodeError:
                WidgetsBinding.instance.addPostFrameCallback((_) =>
                    _showErrorDialog(
                        context,
                        resource.inputFormErrorTitle,
                        resource.invalidPostalCodeError
                    ));
                return Container();
              case ScheduleRegisterStatus.unableSearchAddressError:
                WidgetsBinding.instance.addPostFrameCallback((_) =>
                    _showErrorDialog(
                        context,
                        resource.generalErrorTitle,
                        resource.unableSearchAddressError
                    ));
                return Container();
              case Status.unLoginError:
                WidgetsBinding.instance.addPostFrameCallback((_) =>
                    _showErrorDialog(
                        context,
                        resource.generalErrorTitle,
                        resource.unloginError
                    ));
                return Container();
              case Status.timeoutError:
                WidgetsBinding.instance.addPostFrameCallback((_) =>
                    _showErrorDialog(
                        context,
                        resource.connectionErrorTitle,
                        resource.timeoutError
                    ));
                return Container();
              case Status.httpError:
                WidgetsBinding.instance.addPostFrameCallback((_) =>
                    _showErrorDialog(
                        context,
                        resource.connectionErrorTitle,
                        resource.httpError
                    ));
                return Container();
              case Status.socketError:
                WidgetsBinding.instance.addPostFrameCallback((_) =>
                    _showErrorDialog(
                        context,
                        resource.connectionErrorTitle,
                        resource.socketError
                    ));
                return Container();
              default:
                return Container();
            }
          },
        )
      ],
    );
  }

}