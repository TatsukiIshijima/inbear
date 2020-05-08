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
  static const _homeTitleKey = 'home_title';
  static const _scheduleTitleKey = 'schedule_title';
  static const _settingTitleKey = 'setting_title';

  // スケジュール確認画面
  static const _scheduleGroomTextKey = 'schedule_groom_text';
  static const _scheduleBrideTextKey = 'schedule_bride_text';

  // スケジュール登録画面
  static const _scheduleRegisterTitleKey = 'schedule_register_title';
  static const _scheduleNameLabelTextKey = 'schedule_name_label_text';
  static const _scheduleGroomNameLabelTextKey = 'schedule_groom_name_label_text';
  static const _scheduleBrideNameLabelTextKey = 'schedule_bride_name_label_text';
  static const _scheduleDateLabelTextKey = 'schedule_date_label_text';
  static const _scheduleDateSelectDescriptionKey = 'schedule_date_select_description';
  static const _schedulePlaceLabelTextKey = 'schedule_place_label_text';
  static const _schedulePostalCodeSearchDescriptionKey = 'schedule_postal_code_search_description';
  static const _schedulePostalCodeLabelTextKey = 'schedule_postal_code_label_text';
  static const _scheduleAddressLabelTextKey = 'schedule_address_label_text';
  static const _scheduleRegisterConfirmMessageKey = 'schedule_register_confirm_message';

  // スケジュール切り替え画面
  static const _scheduleSelectTitleKey = 'schedule_select_title';

  // 設定画面
  static const _logoutTitleKey = 'logout_title';
  static const _logoutMessageKey = 'logout_message';

  // 警告
  static const _warningEmptyMessageKey = 'wraning_empty_message';

  // エラー
  static const _connectionErrorTitleKey = 'connection_error_title';
  static const _inputFormErrorTitleKey = 'input_form_error_title';
  static const _generalErrorTitleKey = 'general_error_title';

  static const _emptyErrorMessageKey = 'empty_error_message';
  static const _invalidEmailErrorMessageKey = 'invalid_email_error_message';
  static const _emailAlreadyUsedErrorMessageKey = 'email_already_used_message';
  static const _wrongPasswordErrorMessageKey = 'wrong_password_error_message';
  static const _weakPasswordErrorMessageKey = 'weak_password_error_message';
  static const _userNotFoundErrorMessageKey = 'user_not_found_error_message';
  static const _userDisabledErrorMessageKey = 'user_disabled_error_message';
  static const _invalidCredentialErrorMessageKey = 'invalid_creadential_error_message';
  static const _tooManyRequestsErrorMessageKey = 'too_many_requests_error_message';
  static const _unSelectDateErrorMessageKey = 'unselect_date_error_message';
  static const _invalidPostalCodeErrorMessageKey = 'invalid_postal_code_error_message';
  static const _unableSearchAddressErrorMessageKey = 'unable_search_address_error_message';
  static const _notExistDataErrorMessageKey = 'not_exist_data_error_message';
  static const _timeoutErrorMessageKey = 'timeout_error';
  static const _httpErrorMessageKey = 'http_error';
  static const _socketErrorMessageKey = 'socket_error';
  static const _unLoginErrorMessageKey = 'unlogin_error';
  static const _generalErrorMessageKey = 'general_error_message';

  static const _defaultPositiveButtonTitleKey = 'defalut_positive_button_title';
  static const _defaultNegativeButtonTitleKey = 'defalut_negative_button_title';

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
      _homeTitleKey: 'ホーム',
      _scheduleTitleKey: 'スケジュール',
      _settingTitleKey: '設定',

      // スケジュール確認画面
      _scheduleGroomTextKey: '新郎',
      _scheduleBrideTextKey:'新婦',

      // スケジュール登録画面
      _scheduleRegisterTitleKey: 'スケジュール登録',
      _scheduleNameLabelTextKey: 'お名前',
      _scheduleGroomNameLabelTextKey:'新郎お名前',
      _scheduleBrideNameLabelTextKey:'新婦お名前',
      _scheduleDateLabelTextKey: '日時',
      _scheduleDateSelectDescriptionKey: '日時を選択してください',
      _schedulePlaceLabelTextKey: '場所',
      _schedulePostalCodeSearchDescriptionKey: '郵便番号検索することで市町村までが住所に自動入力されます。',
      _schedulePostalCodeLabelTextKey: '郵便番号（ハイフンなし）',
      _scheduleAddressLabelTextKey: '住所',
      _scheduleRegisterConfirmMessageKey: 'スケジュールを登録します。よろしいですか？',

      // スケジュール切り替え画面
      _scheduleSelectTitleKey: 'スケジュール切り替え',

      // 設定画面
      _logoutTitleKey: 'ログアウト',
      _logoutMessageKey: 'ログアウトしますか？',

      // 警告
      _warningEmptyMessageKey: '未入力です。',
      // エラー
      _connectionErrorTitleKey: '通信エラー',
      _inputFormErrorTitleKey: '入力エラー',
      _generalErrorTitleKey: 'エラー',

      _emptyErrorMessageKey: '必須項目です。',
      _invalidEmailErrorMessageKey: '無効なメールアドレスです。',
      _emailAlreadyUsedErrorMessageKey: '既に使用されているメールアドレスです。',
      _wrongPasswordErrorMessageKey: 'パスワードが間違っています。',
      _weakPasswordErrorMessageKey: 'パスワードが安全ではありません。パスワードは6文字以上入力して下さい。',
      _userNotFoundErrorMessageKey: 'アカウントが見つかりません。',
      _userDisabledErrorMessageKey: '無効なアカウントです',
      _invalidCredentialErrorMessageKey: '無効な認証情報です。',
      _tooManyRequestsErrorMessageKey: 'アクセスが集中しています。\nしばらくしてからもう一度お試し下さい。',
      _unSelectDateErrorMessageKey: '日付が選択されていません。',
      _invalidPostalCodeErrorMessageKey: '無効な郵便番号です。',
      _unableSearchAddressErrorMessageKey: '住所から検索した位置情報が取得できません。\n正しい住所を入力の上、もう一度お試し下さい。',
      _notExistDataErrorMessageKey: 'データが存在しません。',
      _timeoutErrorMessageKey: 'タイムアウトしました。しばらくしてから、もう一度お試し下さい。',
      _httpErrorMessageKey: '通信に失敗しました。接続状態をご確認の上、もう一度お試し下さい。',
      _socketErrorMessageKey: '通信に失敗しました。接続状態をご確認の上、もう一度お試し下さい。',
      _unLoginErrorMessageKey: '未ログイン状態です。再度ログインして下さい。',
      _generalErrorMessageKey: 'エラーが発生しました。\nしばらくしてからもう一度お試し下さい。',

      _defaultPositiveButtonTitleKey: 'OK',
      _defaultNegativeButtonTitleKey: 'キャンセル'
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

  String get homeTitle => _getText(_homeTitleKey);
  String get scheduleTitle => _getText(_scheduleTitleKey);
  String get settingTitle => _getText(_settingTitleKey);

  String get scheduleGroomText => _getText(_scheduleGroomTextKey);
  String get scheduleBrideText => _getText(_scheduleBrideTextKey);
  
  String get scheduleRegisterTitle => _getText(_scheduleRegisterTitleKey);
  String get scheduleNameLabelText => _getText(_scheduleNameLabelTextKey);
  String get scheduleGroomNameLabelText => _getText(_scheduleGroomNameLabelTextKey);
  String get scheduleBrideNameLabelText => _getText(_scheduleBrideNameLabelTextKey);
  String get scheduleDateLabelText => _getText(_scheduleDateLabelTextKey);
  String get scheduleDateSelectDescription => _getText(_scheduleDateSelectDescriptionKey);
  String get schedulePlaceLabelText => _getText(_schedulePlaceLabelTextKey);
  String get schedulePostalCodeSearchDescription => _getText(_schedulePostalCodeSearchDescriptionKey);
  String get schedulePostalCodeLabelText => _getText(_schedulePostalCodeLabelTextKey);
  String get scheduleAddressLabelText => _getText(_scheduleAddressLabelTextKey);
  String get scheduleRegisterConfirmMessage => _getText(_scheduleRegisterConfirmMessageKey);

  String get scheduleChangeTitle => _getText(_scheduleSelectTitleKey);

  String get logoutTitle => _getText(_logoutTitleKey);
  String get logoutMessage => _getText(_logoutMessageKey);

  String get warningEmptyMessage => _getText(_warningEmptyMessageKey);

  String get connectionErrorTitle => _getText(_connectionErrorTitleKey);
  String get inputFormErrorTitle => _getText(_inputFormErrorTitleKey);
  String get generalErrorTitle => _getText(_generalErrorTitleKey);

  String get emptyError => _getText(_emptyErrorMessageKey);
  String get invalidEmailError => _getText(_invalidEmailErrorMessageKey);
  String get alreadyUsedEmailError => _getText(_emailAlreadyUsedErrorMessageKey);
  String get wrongPasswordError => _getText(_wrongPasswordErrorMessageKey);
  String get weakPasswordError => _getText(_weakPasswordErrorMessageKey);
  String get userNotFoundError => _getText(_userNotFoundErrorMessageKey);
  String get userDisabledError => _getText(_userDisabledErrorMessageKey);
  String get invalidCredentialError => _getText(_invalidCredentialErrorMessageKey);
  String get tooManyRequestsError => _getText(_tooManyRequestsErrorMessageKey);
  String get unselectDateError => _getText(_unSelectDateErrorMessageKey);
  String get invalidPostalCodeError => _getText(_invalidPostalCodeErrorMessageKey);
  String get unableSearchAddressError => _getText(_unableSearchAddressErrorMessageKey);
  String get notExistDataError => _getText(_notExistDataErrorMessageKey);
  String get timeoutError => _getText(_timeoutErrorMessageKey);
  String get httpError => _getText(_httpErrorMessageKey);
  String get socketError => _getText(_socketErrorMessageKey);
  String get unloginError => _getText(_unLoginErrorMessageKey);
  String get generalError => _getText(_generalErrorMessageKey);

  String get defaultPositiveButtonTitle => _getText(_defaultPositiveButtonTitleKey);
  String get defaultNegativeButtonTitle => _getText(_defaultNegativeButtonTitleKey);
}