import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/view/widget/input_field.dart';
import 'package:inbear_app/view/widget/loading.dart';
import 'package:inbear_app/view/widget/logo.dart';
import 'package:inbear_app/view/widget/round_button.dart';
import 'package:inbear_app/view/widget/single_button_dialog.dart';
import 'package:inbear_app/viewmodel/login_viewmodel.dart';
import 'package:inbear_app/viewmodel/rest_password_viewmodel.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ResetPasswordViewModel(
        Provider.of<UserRepository>(context, listen: false)
      ),
      child: Scaffold(
        body: ResetPasswordContent()
      ),
    );
  }

}

class ResetPasswordContent extends StatelessWidget {

  void _showAlertDialog(BuildContext context, AuthStatus authStatus) {
    var resource = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) =>
        SingleButtonDialog(
          title: authStatus != AuthStatus.Success ?
            resource.resetPasswordErrorTitle :
            '',
          // TODO:エラーメッセージ統一化
          message: authStatus != AuthStatus.Success ?
            authStatus.toString() :
            resource.resetPasswordSuccessMessage,
          positiveButtonTitle: resource.defaultPositiveButtonTitle,
          onPressed: () => Navigator.pop(context),
        )
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _emailFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    var resource = AppLocalizations.of(context);
    var viewModel = Provider.of<ResetPasswordViewModel>(context);
    return Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: 24, right: 24),
            child: CloseButton(),
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
                  Text(
                    resource.resetPasswordDescription,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600]
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InputField(
                    labelText: resource.emailLabelText,
                    textInputType: TextInputType.emailAddress,
                    textEditingController: viewModel.emailTextEditingController,
                    validator: (text) => text.isEmpty ? resource.emptyError : null,
                    focusNode: _emailFocus,
                    onFieldSubmitted: (text) => _emailFocus.unfocus(),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RoundButton(
                    minWidth: MediaQuery.of(context).size.width,
                    text: resource.resetPasswordButtonTitle,
                    backgroundColor: Colors.pink[200],
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await viewModel.sendPasswordResetEmail();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Selector<ResetPasswordViewModel, AuthStatus>(
            selector: (context, viewModel) => viewModel.authStatus,
            builder: (context, authStatus, child) {
              if (authStatus == AuthStatus.Authenticating) {
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
                    _showAlertDialog(context, authStatus)
                );
              }
              return Container();
            },
          )
        ],
    );
  }

}