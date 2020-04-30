import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/address_repository.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/view/widget/input_field.dart';
import 'package:inbear_app/view/widget/round_button.dart';
import 'package:inbear_app/viewmodel/schedule_register_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ScheduleRegisterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var resource = AppLocalizations.of(context);
    return ChangeNotifierProvider(
      create: (context) => ScheduleRegisterViewModel(
        Provider.of<UserRepository>(context, listen: false),
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
          child: ScheduleRegisterContent(),
        ),
      ),
    );
  }

}

class ScheduleRegisterContent extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final _groomNameFocus = FocusNode();
  final _brideNameFocus = FocusNode();
  final _formatter = new DateFormat('yyyy年MM月dd日(E) HH:mm', 'ja_JP');

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<ScheduleRegisterViewModel>(context, listen: false);
    var now = DateTime.now();
    var resource = AppLocalizations.of(context);
    return SingleChildScrollView(
      child: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.only(top: 24, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  resource.scheduleNameLabelText,
                  style: TextStyle(
                    fontSize: 20
                  ),
                ),
                SizedBox(height: 12,),
                InputField(
                  labelText: resource.scheduleGroomNameLabelText,
                  textInputType: TextInputType.text,
                  textEditingController: null,
                  validator: (text) => text.isEmpty ? resource.emptyError : null,
                  focusNode: _groomNameFocus,
                  onFieldSubmitted: (text) {},
                ),
                SizedBox(height: 24,),
                InputField(
                  labelText: resource.scheduleBrideNameLabelText,
                  textInputType: TextInputType.text,
                  textEditingController: null,
                  validator: (text) => text.isEmpty ? resource.emptyError : null,
                  focusNode: _brideNameFocus,
                  onFieldSubmitted: (text) {},
                ),
                SizedBox(height: 24,),
                Text(
                  resource.scheduleDateLabelText,
                    style: TextStyle(
                        fontSize: 20
                    )
                ),
                SizedBox(height: 12,),
                RaisedButton(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    '${_formatter.format(now)} ~',
                    style: TextStyle(
                      fontSize: 18,
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
                          // TODO:日付表示変更
                        } ,
                        currentTime: DateTime.now()
                    );
                  },
                ),
                SizedBox(height: 24,),
                Text(
                  resource.schedulePlaceLabelText,
                  style: TextStyle(
                      fontSize: 20
                  )
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
                      ),
                    ),
                    SizedBox(width: 1,),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 60,
                        child: FlatButton(
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(
                                  color: Colors.grey
                              )
                          ),
                          color: Colors.grey[400],
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            if (viewModel.validatePostalCode()) {
                              await viewModel.fetchAddress();
                            }
                          },
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
                    focusNode: null,
                    onFieldSubmitted: (text) {
                      // TODO:GoogleMap表示？
                    },
                  ),
                ),
                SizedBox(height: 24,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * ( 3 / 4),
                  color: Colors.blue[100],
                  child: Center(
                    child: Text('GoogleMap表示'),
                  ),
                ),
                SizedBox(height: 24,),
                RoundButton(
                  text: resource.registerButtonTitle,
                  minWidth: MediaQuery.of(context).size.width,
                  backgroundColor: Colors.pink[200],
                  onPressed: () {
                    // TODO:アラート表示のち登録処理
                  },
                )
              ],
            ),
          ),
      ),
    );
  }

}