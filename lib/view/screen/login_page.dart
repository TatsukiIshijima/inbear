import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/status.dart';
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
  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    return ChangeNotifierProvider(
      create: (context) =>
          LoginViewModel(Provider.of<UserRepository>(context, listen: false)),
      child: Scaffold(
        body: LoginPageContent(resource),
      ),
    );
  }
}

class LoginPageContent extends StatelessWidget {
  final AppLocalizations resource;

  LoginPageContent(this.resource);

  final _formKey = GlobalKey<FormState>();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  void _showLoginError(BuildContext context, String message) {
    showDialog<SingleButtonDialog>(
        context: context,
        builder: (context) => SingleButtonDialog(
              title: resource.loginErrorTitle,
              message: message,
              positiveButtonTitle: resource.defaultPositiveButtonTitle,
              onPressed: () => Navigator.pop(context),
            ));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);
    return SingleChildScrollView(
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
                      selector: (context, viewModel) =>
                          viewModel.emailTextEditingController,
                      builder: (context, textEditingController, child) =>
                          InputField(
                        labelText: resource.emailLabelText,
                        textInputType: TextInputType.emailAddress,
                        textEditingController: textEditingController,
                        validator: (text) =>
                            text.isEmpty ? resource.emptyError : null,
                        focusNode: _emailFocus,
                        onFieldSubmitted: (text) =>
                            FocusScope.of(context).requestFocus(_passwordFocus),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Selector<LoginViewModel, TextEditingController>(
                      selector: (context, viewModel) =>
                          viewModel.passwordTextEditingController,
                      builder: (context, textEditingController, child) =>
                          InputField(
                        labelText: resource.passwordLabelText,
                        obscureText: true,
                        textInputType: TextInputType.visiblePassword,
                        textEditingController: textEditingController,
                        validator: (text) =>
                            text.isEmpty ? resource.emptyError : null,
                        focusNode: _passwordFocus,
                        onFieldSubmitted: (text) => _passwordFocus.unfocus(),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    RoundButton(
                      minWidth: MediaQuery.of(context).size.width,
                      text: resource.loginButtonTitle,
                      backgroundColor: Colors.pink[200],
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await viewModel.signIn();
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    LabelButton(
                      text: resource.passwordForgetLabelText,
                      onTap: () {
                        Routes.goToResetPasswordFromLogin(context);
                        viewModel.resetAuthStatus();
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
                  text: resource.createAccountLabelText,
                  onTap: () {
                    Routes.goToRegisterFromLogin(context);
                    viewModel.resetAuthStatus();
                  },
                ),
              ),
            ),
            Selector<LoginViewModel, String>(
              selector: (context, viewModel) => viewModel.authStatus,
              builder: (context, authStatus, child) {
                debugPrint('builder: $authStatus');
                switch (authStatus) {
                  case Status.loading:
                    return Container(
                      decoration:
                          BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.3)),
                      child: Center(
                        child: Loading(),
                      ),
                    );
                  case Status.success:
                    // ビルド前にメソッドが呼ばれるとエラーになるので
                    // addPostFrameCallback で任意処理を実行
                    // https://www.didierboelens.com/2019/04/addpostframecallback/
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => Routes.goToHome(context));
                    break;
                  case AuthStatus.invalidEmailError:
                    WidgetsBinding.instance.addPostFrameCallback((_) =>
                        _showLoginError(context, resource.invalidEmailError));
                    break;
                  case AuthStatus.wrongPasswordError:
                    WidgetsBinding.instance.addPostFrameCallback((_) =>
                        _showLoginError(context, resource.wrongPasswordError));
                    break;
                  case AuthStatus.userNotFoundError:
                    WidgetsBinding.instance.addPostFrameCallback((_) =>
                        _showLoginError(context, resource.userNotFoundError));
                    break;
                  case AuthStatus.userDisabledError:
                    WidgetsBinding.instance.addPostFrameCallback((_) =>
                        _showLoginError(context, resource.userDisabledError));
                    break;
                  case AuthStatus.tooManyRequestsError:
                    WidgetsBinding.instance.addPostFrameCallback((_) =>
                        _showLoginError(
                            context, resource.tooManyRequestsError));
                    break;
                  case AuthStatus.unDefinedError:
                    WidgetsBinding.instance.addPostFrameCallback((_) =>
                        _showLoginError(context, resource.generalErrorTitle));
                    break;
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
