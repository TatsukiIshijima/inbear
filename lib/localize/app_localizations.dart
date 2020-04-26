import 'package:flutter/material.dart';

class AppLocalizations {

  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'ja': {
      'app_title': 'inbear',
      // ログイン画面
      'login_button_title': 'ログイン',
      'email_label_text': 'メールアドレス',
      'password_label_text': 'パスワード',
      'create_account_label_text': '新規登録はこちら',
      'password_forget_label_text': 'パスワードをお忘れの場合はこちら',
      'login_error_title': 'ログインエラー',
      // 新規登録画面
      'register_button_title': '登録',
      'name_label_text': 'お名前',
      // パスワードリセット画面
      'reset_password_title': 'パスワードリセット',
      'reset_password_button_title': '送信',
      'reset_password_description': 'パスワードリセットメールを送信します。アカウントに登録済のメールアドレスを入力してください。',
      'reset_password_error_title': '送信エラー',
      'reset_password_success_message': 'パスワードリセットメールを送信しました。',
      // ホーム画面
      'home_title': 'ホーム',
      'schedule_title': 'スケジュール',
      'setting_title': '設定',
      // 設定画面
      'event_register_title': 'イベント登録',
      'logout_title': 'ログアウト',
      'logout_message': 'ログアウトしますか？',
      // エラー
      'empty_error_message': '必須項目です。',
      'invalid_email_error_message': '無効なメールアドレスです。',
      'wrong_password_error_message': 'パスワードが間違っています。',
      'user_not_found_error_message': 'アカウントが見つかりません。',
      'user_disabled_error_message': '無効なアカウントです',
      'too_many_requests_error_message': 'アクセスが集中しています。\nしばらくしてからもう一度お試し下さい。',
      'general_error_message': 'エラーが発生しました。\nしばらくしてからもう一度お試し下さい。',
      
      'defalut_positive_button_title': 'OK',
      'defalut_negative_button_title': 'キャンセル'
    },
  };

  String _getText(String key) => _localizedValues[locale.languageCode][key];

  String get title => _getText('app_title');

  String get loginButtonTitle => _getText('login_button_title');
  String get emailLabelText => _getText('email_label_text');
  String get passwordLabelText => _getText('password_label_text');
  String get createAccountLabelText => _getText('create_account_label_text');
  String get passwordForgetLabelText => _getText('password_forget_label_text');
  String get loginErrorTitle => _getText('login_error_title');

  String get registerButtonTitle => _getText('register_button_title');
  String get nameLabelText => _getText('name_label_text');

  String get resetPasswordTitle => _getText('reset_password_title');
  String get resetPasswordButtonTitle => _getText('reset_password_button_title');
  String get resetPasswordDescription => _getText('reset_password_description');
  String get resetPasswordErrorTitle => _getText('reset_password_error_title');
  String get resetPasswordSuccessMessage => _getText('reset_password_success_message');

  String get homeTitle => _getText('home_title');
  String get scheduleTitle => _getText('schedule_title');
  String get settingTitle => _getText('setting_title');

  String get eventRegisterTitle => _getText('event_register_title');
  String get logoutTitle => _getText('logout_title');
  String get logtoutMessage => _getText('logout_message');

  String get emptyError => _getText('empty_error_message');
  String get invalidEmailError => _getText('invalid_email_error_message');
  String get wrongPasswordError => _getText('wrong_password_error_message');
  String get userNotFoundError => _getText('user_not_found_error_message');
  String get userDisabledError => _getText('user_disabled_error_message');
  String get tooManyRequestsError => _getText('too_many_requests_error_message');
  String get generalError => _getText('general_error_message');

  String get defaultPositiveButtonTitle => _getText('defalut_positive_button_title');
  String get defaultNegativeButtonTitle => _getText('defalut_negative_button_title');
}