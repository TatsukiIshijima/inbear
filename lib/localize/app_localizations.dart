import 'package:flutter/material.dart';

class AppLocalizations {

  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const _appTitleKey = 'app_title';

  // ログイン画面
  static const _loginButtonTitleKey = 'login_button_title';
  static const _emailLabelTextKey = 'email_label_text';
  static const _passwordLabelTextKey = 'password_label_text';
  static const _createAccountLabelTextKey = 'create_account_label_text';
  static const _passwordForgetLabelTextKey = 'password_forget_label_text';
  static const _loginErrorTitleKey = 'login_error_title';

  // 新規登録画面
  static const _registerButtonTitleKey = 'register_button_title';
  static const _nameLabelTextKey = 'name_label_text';
  static const _registerErrorTitleKey = 'register_error_title';

  // パスワードリセット画面
  static const _resetPasswordTitleKey = 'reset_password_title';
  static const _resetPasswordButtonTitleKey = 'reset_password_button_title';
  static const _resetPasswordDescriptionKey = 'reset_password_description';
  static const _resetPasswordErrorTitleKey = 'reset_password_error_title';
  static const _resetPasswordSuccessMessageKey = 'reset_password_success_message';

  // ホーム画面

  static Map<String, Map<String, String>> _localizedValues = {
    'ja': {
      _appTitleKey: 'inbear',

      // ログイン画面
      _loginButtonTitleKey: 'ログイン',
      _emailLabelTextKey: 'メールアドレス',
      _passwordLabelTextKey: 'パスワード',
      _createAccountLabelTextKey: '新規登録はこちら',
      _passwordForgetLabelTextKey: 'パスワードをお忘れの場合はこちら',
      _loginErrorTitleKey: 'ログインエラー',

      // 新規登録画面
      _registerButtonTitleKey: '登録',
      _nameLabelTextKey: 'お名前',
      _registerErrorTitleKey: '登録エラー',

      // パスワードリセット画面
      _resetPasswordTitleKey: 'パスワードリセット',
      _resetPasswordButtonTitleKey: '送信',
      _resetPasswordDescriptionKey: 'パスワードリセットメールを送信します。アカウントに登録済のメールアドレスを入力してください。',
      _resetPasswordErrorTitleKey: '送信エラー',
      _resetPasswordSuccessMessageKey: 'パスワードリセットメールを送信しました。',

      // ホーム画面
      'home_title': 'ホーム',
      'schedule_title': 'スケジュール',
      'setting_title': '設定',
      // スケジュール画面
      'schedule_groom_text': '新郎',
      'schedule_bride_text':'新婦',
      // 設定画面
      'event_register_title': 'イベント登録',
      'schedule_change_title': 'スケジュール切り替え',
      'logout_title': 'ログアウト',
      'logout_message': 'ログアウトしますか？',
      // スケジュール登録画面
      'schedule_register_title': 'スケジュール登録',
      'schedule_name_label_text': 'お名前',
      'schedule_groom_name_label_text':'新郎お名前',
      'schedule_bride_name_label_text':'新婦お名前',
      'schedule_date_label_text': '日時',
      'schedule_date_select_description': '日時を選択してください',
      'schedule_place_label_text': '場所',
      'schedule_postal_code_search_description': '郵便番号検索することで市町村までが住所に自動入力されます。',
      'schedule_postal_code_label_text': '郵便番号（ハイフンなし）',
      'schedule_address_label_text': '住所',
      'schedule_register_confirm_message': 'スケジュールを登録します。よろしいですか？',

      // 警告
      'wraning_empty_message': '未入力です。',
      // エラー
      'connection_error_title': '通信エラー',
      'input_form_error_title': '入力エラー',
      'general_error_title': 'エラー',

      'empty_error_message': '必須項目です。',
      'invalid_email_error_message': '無効なメールアドレスです。',
      'email_already_used_message': '既に使用されているメールアドレスです。',
      'wrong_password_error_message': 'パスワードが間違っています。',
      'weak_password_error_message': 'パスワードが安全ではありません。パスワードは6文字以上入力して下さい。',
      'user_not_found_error_message': 'アカウントが見つかりません。',
      'user_disabled_error_message': '無効なアカウントです',
      'invalid_creadential_error_message': '無効な認証情報です。',
      'too_many_requests_error_message': 'アクセスが集中しています。\nしばらくしてからもう一度お試し下さい。',
      'unselect_date_error_message': '日付が選択されていません。',
      'invalid_postal_code_error_message': '無効な郵便番号です。',
      'unable_search_address_error_message': '住所から検索した位置情報が取得できません。\n正しい住所を入力の上、もう一度お試し下さい。',
      'not_exist_data_error_message': 'データが存在しません。',
      'timeout_error': 'タイムアウトしました。しばらくしてから、もう一度お試し下さい。',
      'http_error': '通信に失敗しました。接続状態をご確認の上、もう一度お試し下さい。',
      'socket_error': '通信に失敗しました。接続状態をご確認の上、もう一度お試し下さい。',
      'unlogin_error': '未ログイン状態です。再度ログインして下さい。',
      'general_error_message': 'エラーが発生しました。\nしばらくしてからもう一度お試し下さい。',
      
      'defalut_positive_button_title': 'OK',
      'defalut_negative_button_title': 'キャンセル'
    },
  };

  String _getText(String key) => _localizedValues[locale.languageCode][key];

  String get title => _getText(_appTitleKey);

  String get loginButtonTitle => _getText(_loginButtonTitleKey);
  String get emailLabelText => _getText(_emailLabelTextKey);
  String get passwordLabelText => _getText(_passwordLabelTextKey);
  String get createAccountLabelText => _getText(_createAccountLabelTextKey);
  String get passwordForgetLabelText => _getText(_passwordForgetLabelTextKey);
  String get loginErrorTitle => _getText(_loginErrorTitleKey);

  String get registerButtonTitle => _getText(_registerButtonTitleKey);
  String get nameLabelText => _getText(_nameLabelTextKey);
  String get registerErrorTitle => _getText(_registerErrorTitleKey);

  String get resetPasswordTitle => _getText(_resetPasswordTitleKey);
  String get resetPasswordButtonTitle => _getText(_resetPasswordButtonTitleKey);
  String get resetPasswordDescription => _getText(_resetPasswordDescriptionKey);
  String get resetPasswordErrorTitle => _getText(_resetPasswordErrorTitleKey);
  String get resetPasswordSuccessMessage => _getText(_resetPasswordSuccessMessageKey);

  String get homeTitle => _getText('home_title');
  String get scheduleTitle => _getText('schedule_title');
  String get settingTitle => _getText('setting_title');

  String get scheduleGroomText => _getText('schedule_groom_text');
  String get scheduleBrideText => _getText('schedule_bride_text');

  String get scheduleChangeTitle => _getText('schedule_change_title');

  String get logoutTitle => _getText('logout_title');
  String get logoutMessage => _getText('logout_message');
  
  String get scheduleRegisterTitle => _getText('schedule_register_title');
  String get scheduleNameLabelText => _getText('schedule_name_label_text');
  String get scheduleGroomNameLabelText => _getText('schedule_groom_name_label_text');
  String get scheduleBrideNameLabelText => _getText('schedule_bride_name_label_text');
  String get scheduleDateLabelText => _getText('schedule_date_label_text');
  String get scheduleDateSelectDescription => _getText('schedule_date_select_description');
  String get schedulePlaceLabelText => _getText('schedule_place_label_text');
  String get schedulePostalCodeSearchDescription => _getText('schedule_postal_code_search_description');
  String get schedulePostalCodeLabelText => _getText('schedule_postal_code_label_text');
  String get scheduleAddressLabelText => _getText('schedule_address_label_text');
  String get scheduleRegisterConfirmMessage => _getText('schedule_register_confirm_message');

  String get warningEmptyMessage => _getText('wraning_empty_message');

  String get connectionErrorTitle => _getText('connection_error_title');
  String get inputFormErrorTitle => _getText('input_form_error_title');
  String get generalErrorTitle => _getText('general_error_title');

  String get emptyError => _getText('empty_error_message');
  String get invalidEmailError => _getText('invalid_email_error_message');
  String get alreadyUsedEmailError => _getText('email_already_used_message');
  String get wrongPasswordError => _getText('wrong_password_error_message');
  String get weakPasswordError => _getText('weak_password_error_message');
  String get userNotFoundError => _getText('user_not_found_error_message');
  String get userDisabledError => _getText('user_disabled_error_message');
  String get invalidCredentialError => _getText('invalid_creadential_error_message');
  String get tooManyRequestsError => _getText('too_many_requests_error_message');
  String get unselectDateError => _getText('unselect_date_error_message');
  String get invalidPostalCodeError => _getText('invalid_postal_code_error_message');
  String get unableSearchAddressError => _getText('unable_search_address_error_message');
  String get notExistDataError => _getText('not_exist_data_error_message');
  String get timeoutError => _getText('timeout_error');
  String get httpError => _getText('http_error');
  String get socketError => _getText('socket_error');
  String get unloginError => _getText('unlogin_error');
  String get generalError => _getText('general_error_message');

  String get defaultPositiveButtonTitle => _getText('defalut_positive_button_title');
  String get defaultNegativeButtonTitle => _getText('defalut_negative_button_title');
}