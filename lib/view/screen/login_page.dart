import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/status.dart';
import 'package:inbear_app/view/screen/base_page.dart';
import 'package:inbear_app/view/widget/input_field.dart';
import 'package:inbear_app/view/widget/label_button.dart';
import 'package:inbear_app/view/widget/logo.dart';
import 'package:inbear_app/view/widget/round_button.dart';
import 'package:inbear_app/view/widget/single_button_dialog.dart';
import 'package:inbear_app/viewmodel/login_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../routes.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage<LoginViewModel>(
      viewModel:
          LoginViewModel(Provider.of<UserRepository>(context, listen: false)),
      child: Scaffold(
        body: LoginPageBody(),
      ),
    );
  }
}

class LoginPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Center(
              child: SingleChildScrollView(
            child: LoginForm(),
          )),
          AuthAlertDialog(),
        ],
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Logo(
                fontSize: 80,
              ),
              const SizedBox(
                height: 30,
              ),
              Selector<LoginViewModel, TextEditingController>(
                selector: (context, viewModel) =>
                    viewModel.emailTextEditingController,
                builder: (context, textEditingController, child) => InputField(
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
              const SizedBox(
                height: 30,
              ),
              Selector<LoginViewModel, TextEditingController>(
                selector: (context, viewModel) =>
                    viewModel.passwordTextEditingController,
                builder: (context, textEditingController, child) => InputField(
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
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                minWidth: MediaQuery.of(context).size.width,
                text: resource.loginButtonTitle,
                backgroundColor: Colors.pink[200],
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    await viewModel.executeSignIn();
                  }
                },
              ),
              const SizedBox(
                height: 12,
              ),
              LabelButton(
                text: resource.passwordForgetLabelText,
                onTap: () {
                  Routes.goToResetPasswordFromLogin(context);
                  viewModel.resetAuthStatus();
                },
              ),
              const SizedBox(
                height: 30,
              ),
              LabelButton(
                text: resource.createAccountLabelText,
                onTap: () {
                  Routes.goToRegisterFromLogin(context);
                  viewModel.resetAuthStatus();
                },
              ),
            ],
          ),
        ));
  }
}

class AuthAlertDialog extends StatelessWidget {
  void _showLoginError(BuildContext context, String message) {
    final resource = AppLocalizations.of(context);
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => showDialog<SingleButtonDialog>(
            context: context,
            builder: (context) => SingleButtonDialog(
                  title: resource.loginErrorTitle,
                  message: message,
                  positiveButtonTitle: resource.defaultPositiveButtonTitle,
                  onPressed: () => Navigator.pop(context),
                )));
  }

  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    return Selector<LoginViewModel, String>(
      selector: (context, viewModel) => viewModel.status,
      builder: (context, status, child) {
        switch (status) {
          case Status.success:
            // ビルド前にメソッドが呼ばれるとエラーになるので
            // addPostFrameCallback で任意処理を実行
            // https://www.didierboelens.com/2019/04/addpostframecallback/
            WidgetsBinding.instance
                .addPostFrameCallback((_) => Routes.goToHome(context));
            break;
          case AuthStatus.invalidEmailError:
            _showLoginError(context, resource.invalidEmailError);
            break;
          case AuthStatus.wrongPasswordError:
            _showLoginError(context, resource.wrongPasswordError);
            break;
          case AuthStatus.userNotFoundError:
            _showLoginError(context, resource.userNotFoundError);
            break;
          case AuthStatus.userDisabledError:
            _showLoginError(context, resource.userDisabledError);
            break;
          case AuthStatus.tooManyRequestsError:
            _showLoginError(context, resource.tooManyRequestsError);
            break;
        }
        return Container();
      },
    );
  }
}
