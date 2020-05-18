import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/status.dart';
import 'package:inbear_app/view/widget/input_field.dart';
import 'package:inbear_app/view/widget/loading.dart';
import 'package:inbear_app/view/widget/logo.dart';
import 'package:inbear_app/view/widget/round_button.dart';
import 'package:inbear_app/view/widget/single_button_dialog.dart';
import 'package:inbear_app/viewmodel/rest_password_viewmodel.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    return ChangeNotifierProvider(
      create: (context) => ResetPasswordViewModel(
          Provider.of<UserRepository>(context, listen: false)),
      child: Scaffold(body: ResetPasswordContent(resource)),
    );
  }
}

class ResetPasswordContent extends StatelessWidget {
  final AppLocalizations resource;

  ResetPasswordContent(this.resource);

  void _showResetPasswordDialog(
      BuildContext context, String title, String message) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showDialog<SingleButtonDialog>(
          context: context,
          builder: (context) => SingleButtonDialog(
                title: title,
                message: message,
                positiveButtonTitle: resource.defaultPositiveButtonTitle,
                onPressed: () => Navigator.pop(context),
              ));
    });
  }

  Widget _resetPasswordStatusWidget() {
    return Selector<ResetPasswordViewModel, String>(
      selector: (context, viewModel) => viewModel.authStatus,
      builder: (context, authStatus, child) {
        switch (authStatus) {
          case Status.loading:
            return Container(
              decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.3)),
              child: Center(
                child: Loading(),
              ),
            );
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
          case AuthStatus.tooManyRequestsError:
            _showResetPasswordDialog(context, resource.resetPasswordTitle,
                resource.tooManyRequestsError);
            break;
          case Status.networkError:
            _showResetPasswordDialog(
                context, resource.resetPasswordTitle, resource.networkError);
            break;
          case Status.timeoutError:
            _showResetPasswordDialog(
                context, resource.resetPasswordTitle, resource.timeoutError);
            break;
        }
        return Container();
      },
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _emailFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    // ルートページでなければ、pushの時点で build が呼ばれ、
    // pop の時点で viewModel の dispose が呼ばれている
    final viewModel =
        Provider.of<ResetPasswordViewModel>(context, listen: false);
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(top: 24, right: 24),
              child: CloseButton(),
            ),
            Center(
              child: Form(
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
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InputField(
                        labelText: resource.emailLabelText,
                        textInputType: TextInputType.emailAddress,
                        textEditingController:
                            viewModel.emailTextEditingController,
                        validator: (text) =>
                            text.isEmpty ? resource.emptyError : null,
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
            ),
            _resetPasswordStatusWidget(),
          ],
        ),
      ),
    );
  }
}
