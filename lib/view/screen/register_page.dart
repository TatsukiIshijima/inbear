import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/auth_status.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/routes.dart';
import 'package:inbear_app/view/widget/input_field.dart';
import 'package:inbear_app/view/widget/loading.dart';
import 'package:inbear_app/view/widget/logo.dart';
import 'package:inbear_app/view/widget/round_button.dart';
import 'package:inbear_app/view/widget/single_button_dialog.dart';
import 'package:inbear_app/viewmodel/register_viewmodel.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterViewModel(
        Provider.of<UserRepository>(context, listen: false)
      ),
      child: Scaffold(
          body: RegisterPageContent()
      ),
    );
  }
}

class RegisterPageContent extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  void _showRegisterError(BuildContext context, AuthStatus authStatus) {
    var resource = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) =>
        SingleButtonDialog(
          title: resource.registerErrorTitle,
          message: AuthStatusExtension.toMessage(context, authStatus),
          positiveButtonTitle: resource.defaultPositiveButtonTitle,
          onPressed: () => Navigator.pop(context),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    var resource = AppLocalizations.of(context);
    var viewModel = Provider.of<RegisterViewModel>(context, listen: false);
    return SingleChildScrollView(
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
                    const SizedBox(
                      height: 30,
                    ),
                    Selector<RegisterViewModel, TextEditingController>(
                      selector: (context, viewModel) => viewModel.nameTextEditingController,
                      builder: (context, textEditingController, child) =>
                          InputField(
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
                    Selector<RegisterViewModel, TextEditingController>(
                      selector: (context, viewModel) => viewModel.emailTextEditingController,
                      builder: (context, textEditingController, child) =>
                          InputField(
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
                    Selector<RegisterViewModel, TextEditingController>(
                      selector: (context, viewModel) => viewModel.passwordTextEditingController,
                      builder: (context, textEditingController, child) =>
                          InputField(
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
                          await viewModel.signUp();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Selector<RegisterViewModel, AuthStatus>(
              selector: (context, viewModel) => viewModel.authStatus,
              builder: (context, authStatus, child) {
                if (authStatus == AuthStatus.Success) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // 一旦popで新規画面をクローズしてから
                    // ルートをホーム画面に設定して遷移させることで
                    // ホーム遷移後にバックボタン押下でアプリ終了とさせる
                    Navigator.pop(context);
                    Routes.goToHome(context);
                  });
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
                    _showRegisterError(context, authStatus)
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }

}