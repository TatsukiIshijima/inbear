import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/status.dart';
import 'package:inbear_app/view/screen/base_page.dart';
import 'package:inbear_app/view/widget/default_dialog.dart';
import 'package:inbear_app/view/widget/input_field.dart';
import 'package:inbear_app/view/widget/logo.dart';
import 'package:inbear_app/view/widget/round_button.dart';
import 'package:inbear_app/viewmodel/reset_password_viewmodel.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage<ResetPasswordViewModel>(
      viewModel: ResetPasswordViewModel(
          Provider.of<UserRepository>(context, listen: false)),
      child: Scaffold(body: ResetPasswordPageBody()),
    );
  }
}

class ResetPasswordPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: 24, right: 24),
            child: CloseButton(),
          ),
          Center(
            child: SingleChildScrollView(
              child: ResetPasswordForm(),
            ),
          ),
          ResetPasswordAlertDialog()
        ],
      ),
    );
  }
}

class ResetPasswordForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    // ルートページでなければ、pushの時点で build が呼ばれ、
    // pop の時点で viewModel の dispose が呼ばれている
    final viewModel =
        Provider.of<ResetPasswordViewModel>(context, listen: false);
    final resource = AppLocalizations.of(context);
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
            Text(
              resource.resetPasswordDescription,
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(
              height: 20,
            ),
            InputField(
              resource.emailLabelText,
              viewModel.emailTextEditingController,
              maxLength: 32,
              textInputType: TextInputType.emailAddress,
              validator: (text) => text.isEmpty ? resource.emptyError : null,
              focusNode: _emailFocus,
              onFieldSubmitted: (text) => _emailFocus.unfocus(),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
              minWidth: MediaQuery.of(context).size.width,
              text: resource.resetPasswordButtonTitle,
              backgroundColor: Colors.pink[200],
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  await viewModel.executeSendResetPasswordMail();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ResetPasswordAlertDialog extends StatelessWidget {
  void _showResetPasswordDialog(
      BuildContext context, String title, String message) {
    final resource = AppLocalizations.of(context);
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => showDialog<DefaultDialog>(
            context: context,
            builder: (context) => DefaultDialog(
                  title,
                  message,
                  positiveButtonTitle: resource.defaultPositiveButtonTitle,
                  onPositiveButtonPressed: () {},
                )));
  }

  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    return Selector<ResetPasswordViewModel, Status>(
      selector: (context, viewModel) => viewModel.status,
      builder: (context, authStatus, child) {
        switch (authStatus) {
          case Status.success:
            _showResetPasswordDialog(context, resource.resetPasswordTitle,
                resource.resetPasswordSuccessMessage);
            break;
          case AuthStatus.invalidEmailError:
            _showResetPasswordDialog(context, resource.resetPasswordErrorTitle,
                resource.invalidEmailError);
            break;
          case AuthStatus.userNotFoundError:
            _showResetPasswordDialog(context, resource.resetPasswordTitle,
                resource.userNotFoundError);
            break;
          case AuthStatus.userDisabledError:
            _showResetPasswordDialog(context, resource.resetPasswordTitle,
                resource.userDisabledError);
            break;
          case Status.tooManyRequestsError:
            _showResetPasswordDialog(context, resource.resetPasswordTitle,
                resource.tooManyRequestsError);
            break;
        }
        return Container();
      },
    );
  }
}
