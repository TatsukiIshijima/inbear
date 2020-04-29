import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/view/widget/input_field.dart';
import 'package:inbear_app/view/widget/round_button.dart';
import 'package:intl/intl.dart';

class ScheduleRegisterPage extends StatelessWidget {

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
      body:  ScheduleRegisterContent(),
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
    var now = DateTime.now();
    var resource = AppLocalizations.of(context);
    return SingleChildScrollView(
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InputField(
                labelText: '新郎お名前',
                textInputType: TextInputType.text,
                textEditingController: null,
                validator: (text) => text.isEmpty ? resource.emptyError : null,
                focusNode: _groomNameFocus,
                onFieldSubmitted: (text) {},
              ),
              InputField(
                labelText: '新婦お名前',
                textInputType: TextInputType.text,
                textEditingController: null,
                validator: (text) => text.isEmpty ? resource.emptyError : null,
                focusNode: _brideNameFocus,
                onFieldSubmitted: (text) {},
              ),
              Text('日時'),
              RaisedButton(
                padding: EdgeInsets.all(20),
                child: Text('${_formatter.format(now)} ~'),
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
              Text('場所'),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: InputField(
                      labelText: '郵便番号',
                      textInputType: TextInputType.number,
                      textEditingController: null,
                      validator: (text) => text.isEmpty ? '未入力です': null,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: RaisedButton(
                      child: Text('検索'),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
              InputField(
                labelText: '住所',
                textInputType: TextInputType.text,
                textEditingController: null,
                validator: (text) => text.isEmpty ? resource.emptyError : null,
                focusNode: null,
                onFieldSubmitted: (text) {
                  // TODO:GoogleMap表示？
                },
              ),
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
    );
  }

}