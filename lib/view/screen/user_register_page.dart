import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/routes.dart';
import 'package:inbear_app/status.dart';
import 'package:inbear_app/view/screen/base_page.dart';
import 'package:inbear_app/view/widget/default_dialog.dart';
import 'package:inbear_app/view/widget/input_field.dart';
import 'package:inbear_app/view/widget/logo.dart';
import 'package:inbear_app/view/widget/round_button.dart';
import 'package:inbear_app/viewmodel/user_register_viewmodel.dart';
import 'package:provider/provider.dart';

class UserRegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage<UserRegisterViewModel>(
      viewModel: UserRegisterViewModel(
          Provider.of<UserRepository>(context, listen: false)),
      child: Scaffold(body: UserRegisterBody()),
    );
  }
}

class UserRegisterBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(top: 24, right: 24),
              child: CloseButton()),
          Center(
            child: SingleChildScrollView(
              child: UserRegisterForm(),
            ),
          ),
          AuthAlertDialog()
        ],
      ),
    );
  }
}

class UserRegisterForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    final viewModel =
        Provider.of<UserRegisterViewModel>(context, listen: false);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Logo(
              fontSize: 80,
            ),
            const SizedBox(
              height: 30,
            ),
            Selector<UserRegisterViewModel, TextEditingController>(
              selector: (context, viewModel) =>
                  viewModel.nameTextEditingController,
              builder: (context, textEditingController, child) => InputField(
                labelText: resource.nameLabelText,
                textInputType: TextInputType.text,
                textEditingController: textEditingController,
                validator: (text) => text.isEmpty ? resource.emptyError : null,
                focusNode: _nameFocus,
                onFieldSubmitted: (text) =>
                    FocusScope.of(context).requestFocus(_emailFocus),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Selector<UserRegisterViewModel, TextEditingController>(
              selector: (context, viewModel) =>
                  viewModel.emailTextEditingController,
              builder: (context, textEditingController, child) => InputField(
                labelText: resource.emailLabelText,
                textInputType: TextInputType.emailAddress,
                textEditingController: textEditingController,
                validator: (text) => text.isEmpty ? resource.emptyError : null,
                focusNode: _emailFocus,
                onFieldSubmitted: (text) =>
                    FocusScope.of(context).requestFocus(_passwordFocus),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Selector<UserRegisterViewModel, TextEditingController>(
              selector: (context, viewModel) =>
                  viewModel.passwordTextEditingController,
              builder: (context, textEditingController, child) => InputField(
                labelText: resource.passwordLabelText,
                obscureText: true,
                textInputType: TextInputType.visiblePassword,
                textEditingController: textEditingController,
                validator: (text) => text.isEmpty ? resource.emptyError : null,
                focusNode: _passwordFocus,
                onFieldSubmitted: (text) => _passwordFocus.unfocus(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
              minWidth: MediaQuery.of(context).size.width,
              text: resource.registerButtonTitle,
              backgroundColor: Colors.pink[200],
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  await viewModel.executeSignUp();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AuthAlertDialog extends StatelessWidget {
  void _showRegisterError(BuildContext context, String message) {
    final resource = AppLocalizations.of(context);
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => showDialog<DefaultDialog>(
            context: context,
            builder: (context) => DefaultDialog(
                  resource.registerErrorTitle,
                  message,
                  positiveButtonTitle: resource.defaultPositiveButtonTitle,
                  onPositiveButtonPressed: () {},
                )));
  }

  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    return Selector<UserRegisterViewModel, String>(
      selector: (context, viewModel) => viewModel.status,
      builder: (context, authStatus, child) {
        switch (authStatus) {
          case Status.success:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // 一旦popで新規画面をクローズしてから
              // ルートをホーム画面に設定して遷移させることで
              // ホーム遷移後にバックボタン押下でアプリ終了とさせる
              Navigator.pop(context);
              Routes.goToHome(context);
            });
            break;
          case AuthStatus.weakPasswordError:
            _showRegisterError(context, resource.weakPasswordError);
            break;
          case AuthStatus.invalidEmailError:
            _showRegisterError(context, resource.invalidEmailError);
            break;
          case AuthStatus.emailAlreadyUsedError:
            _showRegisterError(context, resource.alreadyUsedEmailError);
            break;
          case AuthStatus.invalidCredentialError:
            _showRegisterError(context, resource.invalidCredentialError);
            break;
          case AuthStatus.tooManyRequestsError:
            _showRegisterError(context, resource.tooManyRequestsError);
            break;
        }
        return Container();
      },
    );
  }
}
