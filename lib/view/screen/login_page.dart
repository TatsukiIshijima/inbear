import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/view/widget/input_field.dart';
import 'package:inbear_app/view/widget/label_button.dart';
import 'package:inbear_app/view/widget/loading.dart';
import 'package:inbear_app/view/widget/logo.dart';
import 'package:inbear_app/view/widget/round_button.dart';
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
        userRepository: Provider.of<UserRepository>(context, listen: false)
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
                        Consumer<LoginViewModel>(
                          builder: (context, viewModel, child) =>
                            InputField(
                              labelText: AppLocalizations.of(context).emailLabelText,
                              textInputType: TextInputType.emailAddress,
                              textEditingController: viewModel.emailTextEditingController,
                              validator: (text) => _checkEmpty(context, text),
                              focusNode: _emailFocus,
                              onFieldSubmitted: (text) => FocusScope.of(context).requestFocus(_passwordFocus),
                            ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Consumer<LoginViewModel>(
                          builder: (context, viewModel, child) =>
                            InputField(
                              labelText: AppLocalizations.of(context).passwordLabelText,
                              obscureText: true,
                              textInputType: TextInputType.visiblePassword,
                              textEditingController: viewModel.passwordTextEditingController,
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
                                    Routes.goToHome(context);
                                    /*
                                    await viewModel.signIn();
                                    if (viewModel.authStatus == AuthStatus.Success) {
                                      Routes.goToHome(context);
                                    } else if (
                                        viewModel.authStatus != AuthStatus.Authenticating ||
                                        viewModel.authStatus != null) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SingleButtonDialog(
                                              title: AppLocalizations.of(context).loginErrorTitle,
                                              message: viewModel.toLoginErrorMessage(context),
                                              positiveButtonTitle: AppLocalizations.of(context).defaultPositiveButtonTitle,
                                            );
                                          }
                                      );
                                    }

                                     */
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
                Consumer<LoginViewModel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.authStatus == AuthStatus.Authenticating) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 0.3)
                        ),
                        child: Center(
                          child: Loading(),
                        ),
                      );
                    }
                    return Container();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
