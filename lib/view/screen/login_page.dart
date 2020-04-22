import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/view/widget/input_field.dart';
import 'package:inbear_app/view/widget/label_button.dart';
import 'package:inbear_app/view/widget/loading.dart';
import 'package:inbear_app/view/widget/logo.dart';
import 'package:inbear_app/view/widget/round_button.dart';
import 'package:inbear_app/view/widget/single_button_dialog.dart';
import 'package:inbear_app/viewmodel/login_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../routes.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  String _checkEmpty(BuildContext context, String text) {
    return text.isEmpty ? AppLocalizations.of(context).emptyError : null;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(
          Provider.of<UserRepository>(context, listen: false)
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
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
                        Selector<LoginViewModel, TextEditingController>(
                          selector: (context, viewModel) => viewModel.emailTextEditingController,
                          builder: (context, textEditingController, child) =>
                              InputField(
                                labelText: AppLocalizations.of(context).emailLabelText,
                                textInputType: TextInputType.emailAddress,
                                textEditingController: textEditingController,
                                validator: (text) => _checkEmpty(context, text),
                                focusNode: _emailFocus,
                                onFieldSubmitted: (text) => FocusScope.of(context).requestFocus(_passwordFocus),
                              ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Selector<LoginViewModel, TextEditingController>(
                          selector: (context, viewModel) => viewModel.passwordTextEditingController,
                          builder: (context, textEditingController, child) =>
                              InputField(
                                labelText: AppLocalizations.of(context).passwordLabelText,
                                obscureText: true,
                                textInputType: TextInputType.visiblePassword,
                                textEditingController: textEditingController,
                                validator: (text) => _checkEmpty(context, text),
                                focusNode: _passwordFocus,
                                onFieldSubmitted: (text) => _passwordFocus.unfocus(),
                              ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Consumer<LoginViewModel>(
                          builder: (context, viewModel, child) =>
                              RoundButton(
                                minWidth: MediaQuery.of(context).size.width,
                                text: AppLocalizations.of(context).loginButtonTitle,
                                backgroundColor: Colors.pink[200],
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    await viewModel.signIn();
                                  }
                                },
                              ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        LabelButton(
                          text: AppLocalizations.of(context).passwordForgetLabelText,
                          onTap: () => {
                            // TODO:パスワード忘れ
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(bottom: 24),
                  child: SafeArea(
                    child: LabelButton(
                      text: AppLocalizations.of(context).createAccountLabelText,
                      onTap: () => Routes.goToRegisterFromLogin(context),
                    ),
                  ),
                ),
                Selector<LoginViewModel, AuthStatus>(
                  selector: (context, viewModel) => viewModel.authStatus,
                  builder: (context, authStatus, child) {
                    if (authStatus == AuthStatus.Success) {
                      // ビルド前にメソッドが呼ばれるとエラーになるので
                      // addPostFrameCallback で任意処理を実行
                      // https://www.didierboelens.com/2019/04/addpostframecallback/
                      WidgetsBinding.instance.addPostFrameCallback((_) =>
                          Routes.goToHome(context));
                    } else if (authStatus == AuthStatus.Authenticating) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 0.3)
                        ),
                        child: Center(
                          child: Loading(),
                        ),
                      );
                    } else if (authStatus != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) =>
                      // FIXME:CupertinoAlertDialogの場合クラッシュ
                      // https://jg-ravity.com/?p=833
                        showDialog(
                            context: context,
                            builder: (context) =>
                                SingleButtonDialog(
                                  title: AppLocalizations.of(context).loginErrorTitle,
                                  // TODO:変換メソッド
                                  message: authStatus.toString(),
                                  positiveButtonTitle: AppLocalizations.of(context).defaultPositiveButtonTitle,
                              )
                        )
                      );
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
