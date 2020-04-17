import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/view/widget/input_field.dart';
import 'package:inbear_app/view/widget/label_button.dart';
import 'package:inbear_app/view/widget/logo.dart';
import 'package:inbear_app/view/widget/round_button.dart';

import '../../strings.dart';

class LoginPage extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();

  String _checkEmpty(String text) {
    return text.isEmpty ? Strings.emptyStringError : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Logo(fontSize: 80,),
                        SizedBox(height: 30,),
                        InputField(
                          labelText: Strings.EmailLabelText,
                          textInputType: TextInputType.emailAddress,
                          textEditingController: _emailTextEditingController,
                          validator: (text) => _checkEmpty(text),
                          focusNode: _emailFocus,
                          onFieldSubmitted: (text) =>
                              FocusScope.of(context).requestFocus(_passwordFocus),
                        ),
                        SizedBox(height: 30,),
                        InputField(
                          labelText: Strings.PasswordLabelText,
                          obscureText: true,
                          textInputType: TextInputType.visiblePassword,
                          textEditingController: _passwordTextEditingController,
                          validator: (text) => _checkEmpty(text),
                          focusNode: _passwordFocus,
                          onFieldSubmitted: (text) => _passwordFocus.unfocus(),
                        ),
                        SizedBox(height: 30,),
                        RoundButton(
                          minWidth: MediaQuery.of(context).size.width,
                          text: Strings.LoginButtonTitle,
                          backgroundColor: Colors.pink[200],
                          onPressed: () => {
                            if (_formKey.currentState.validate()) {
                              // TODO:ログイン処理
                            }
                          },
                        ),
                        SizedBox(height: 10,),
                        LabelButton(
                          text: Strings.PasswordForgetLabelTitle,
                          onTap: () => {
                            // TODO:パスワード忘れ
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(bottom: 24),
                    child: LabelButton(
                      text: Strings.CreateAccountLabelTitle,
                      onTap: () => {
                        // TODO:新規登録画面へ遷移
                      },
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}