import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/routes.dart';
import 'package:inbear_app/view/widget/input_field.dart';
import 'package:inbear_app/view/widget/logo.dart';
import 'package:inbear_app/view/widget/round_button.dart';

class RegisterPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _nameTextEditingController = TextEditingController();
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();

  String _checkEmpty(BuildContext context, String text) {
    return text.isEmpty ? AppLocalizations.of(context).emptyError : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(top: 24, right: 24),
                child: SafeArea(
                  child: CloseButton(),
                ),
              ),
              Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Logo(
                        fontSize: 80,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      InputField(
                        labelText: AppLocalizations.of(context).nameLabelText,
                        textInputType: TextInputType.text,
                        textEditingController: _nameTextEditingController,
                        validator: (text) => _checkEmpty(context, text),
                        focusNode: _nameFocus,
                        onFieldSubmitted: (text) =>
                          FocusScope.of(context).requestFocus(_emailFocus),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      InputField(
                        labelText: AppLocalizations.of(context).emailLabelText,
                        textInputType: TextInputType.emailAddress,
                        textEditingController: _emailTextEditingController,
                        validator: (text) => _checkEmpty(context, text),
                        focusNode: _emailFocus,
                        onFieldSubmitted: (text) =>
                            FocusScope.of(context).requestFocus(_passwordFocus),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      InputField(
                        labelText: AppLocalizations.of(context).passwordLabelText,
                        obscureText: true,
                        textInputType: TextInputType.visiblePassword,
                        textEditingController: _passwordTextEditingController,
                        validator: (text) => _checkEmpty(context, text),
                        focusNode: _passwordFocus,
                        onFieldSubmitted: (text) => _passwordFocus.unfocus(),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      RoundButton(
                        minWidth: MediaQuery.of(context).size.width,
                        text: AppLocalizations.of(context).registerButtonTitle,
                        backgroundColor: Colors.pink[200],
                        onPressed: () => {
                          if (_formKey.currentState.validate())
                            {
                              // TODO:登録処理
                              // 仮でホーム画面へ遷移
                              // FIXME:ホームに遷移しても戻るボタンが表示されて戻れる
                              Routes.goToHome(context)
                            }
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}