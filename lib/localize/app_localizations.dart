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
  static const _resetPasswordSuccessMessageKey =
      'reset_password_success_message';

  // ホーム画面
  static const _homeTitleKey = 'home_title';
  static const _scheduleTitleKey = 'schedule_title';
  static const _settingTitleKey = 'setting_title';
  static const _introductionTitleKey = 'introduction_title';
  static const _introductionMessageKey = 'introduction_message';
  static const _dearNewPairTitleKey = 'dear_new_pair_title';
  static const _dearNewPairMessageKey = 'dear_new_pair_message';
  static const _dearOrdinaryPersonTitleKey = 'person_ordinary_person_title';
  static const _dearOrdinaryPersonMessageKey = 'person_ordinary_person_message';

  // 画像一覧画面
  static const _albumNotRegisterKey = 'album_not_register';

  // 画像プレビュー画面
  static const _photoPreviewTitleKey = 'photo_preview_title';
  static const _photoPreviewDeleteConfirmTitleKey =
      'photo_preview_delete_confirm_title';
  static const _photoPreviewDeleteConfirmMessageKey =
      'photo_preview_delete_confirm_message';

  // スケジュール確認画面
  static const _scheduleGroomTextKey = 'schedule_groom_text';
  static const _scheduleBrideTextKey = 'schedule_bride_text';

  // スケジュール登録画面
  static const _scheduleRegisterTitleKey = 'schedule_register_title';
  static const _scheduleNameLabelTextKey = 'schedule_name_label_text';
  static const _scheduleGroomNameLabelTextKey =
      'schedule_groom_name_label_text';
  static const _scheduleBrideNameLabelTextKey =
      'schedule_bride_name_label_text';
  static const _scheduleDateLabelTextKey = 'schedule_date_label_text';
  static const _scheduleDateSelectDescriptionKey =
      'schedule_date_select_description';
  static const _schedulePlaceLabelTextKey = 'schedule_place_label_text';
  static const _schedulePostalCodeSearchDescriptionKey =
      'schedule_postal_code_search_description';
  static const _schedulePostalCodeLabelTextKey =
      'schedule_postal_code_label_text';
  static const _scheduleAddressLabelTextKey = 'schedule_address_label_text';
  static const _scheduleRegisterConfirmMessageKey =
      'schedule_register_confirm_message';

  // スケジュール切り替え画面
  static const _scheduleSelectTitleKey = 'schedule_select_title';
  static const _scheduleSelectConfirmTitleKey = 'schedule_select_confirm_title';
  static const _scheduleSelectConfirmMessageKey =
      'schedule_select_confirm_message';

  // 参加者一覧画面
  static const _participantsEmptyErrorMessageKey =
      'participants_empty_error_message';
  static const _deleteParticipantConfirmTitleKey =
      'delete_participant_confirm_title';
  static const _deleteParticipantConfirmMessageKey =
      'delete_participant_confirm_message';

  // 参加者追加画面
  static const _addParticipantSuggestMessageKey =
      'add_participant_suggest_message';
  static const _notFountEmailAddressUserMessageKey =
      'not_found_email_address_message';
  static const _addParticipantErrorTitle = 'add_participant_error_title';

  // 設定画面
  static const _userTitleKey = 'user_title';
  static const _logoutTitleKey = 'logout_title';
  static const _logoutMessageKey = 'logout_message';
  static const _licenseTitleKey = 'license_title';
  static const _versionTitleKey = 'version_title';

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
  static const _invalidCredentialErrorMessageKey =
      'invalid_creadential_error_message';
  static const _tooManyRequestsErrorMessageKey =
      'too_many_requests_error_message';
  static const _unSelectDateErrorMessageKey = 'unselect_date_error_message';
  static const _invalidPostalCodeErrorMessageKey =
      'invalid_postal_code_error_message';
  static const _unableSearchAddressErrorMessageKey =
      'unable_search_address_error_message';
  static const _overDailyLimitErrorKey = 'over_daily_limit_error_message';
  static const _requestDeniedErrorKey = 'request_denied_error_message';
  static const _invalidRequestErrorKey = 'invalid_request_error_message';
  static const _notExistDataErrorMessageKey = 'not_exist_data_error_message';
  static const _notExistUserDataErrorMessageKey =
      'not_exist_user_data_error_message';
  static const _notExistScheduleDataErrorMessageKey =
      'not_exist_schedule_data_error_message';
  static const _notExistEntryScheduleErrorMessageKey =
      'not_exist_entry_schedule_error_message';
  static const _noSelectScheduleErrorMessageKey =
      'no_select_schedule_error_message';
  static const _uploadImageErrorTitleKey = '_upload_image_error_title';
  static const _uploadImageErrorMessageKey = '_upload_image_error_message';
  static const _permissionErrorTitleKey = '_permission_error_title';
  static const _photoPermissionDeniedErrorMessageKey =
      'photo_permission_denied_error_message';
  static const _photoPermissionPermanentlyDeniedErrorMessageKey =
      'photo_permission_permanently_denied_error_message';
  static const _timeoutErrorMessageKey = 'timeout_error';
  static const _badRequestErrorMessageKey = 'bad_request_error';
  static const _notFoundErrorMessageKey = 'not_found_error';
  static const _methodNotAllowErrorMessageKey = 'method_not_allow_message';
  static const _httpErrorMessageKey = 'http_error';
  static const _socketErrorMessageKey = 'socket_error';
  static const _networkErrorMessageKey = 'network_error';
  static const _unLoginErrorMessageKey = 'unlogin_error';
  static const _generalErrorMessageKey = 'general_error_message';

  static const _reloadMessageKey = 'reload_message';
  static const _defaultPositiveButtonTitleKey = 'defalut_positive_button_title';
  static const _defaultNegativeButtonTitleKey = 'defalut_negative_button_title';

  static final Map<String, Map<String, String>> _localizedValues = {
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
      _resetPasswordDescriptionKey:
          'パスワードリセットメールを送信します。アカウントに登録済のメールアドレスを入力してください。',
      _resetPasswordErrorTitleKey: '送信エラー',
      _resetPasswordSuccessMessageKey: 'パスワードリセットメールを送信しました。',

      // ホーム画面
      _homeTitleKey: 'ホーム',
      _scheduleTitleKey: 'スケジュール',
      _settingTitleKey: '設定',
      _introductionTitleKey: 'はじめに',
      _introductionMessageKey: 'inbearは結婚式の写真、\nスケジュール、参加者などを\n共有できるアプリです。',
      _dearNewPairTitleKey: '新郎、新婦の方へ',
      _dearNewPairMessageKey:
          'まずはスケジュールを\n登録しましょう。\n新郎、新婦のどちらかがスケジュール登録済みの場合は参加者一覧から一方を追加してみましょう。',
      _dearOrdinaryPersonTitleKey: '参加者の方へ',
      _dearOrdinaryPersonMessageKey:
          '表示するスケジュールの\n選択をしましょう。\n新郎、新婦からスケジュールへの参加を許可されている場合は一覧に表示されるので、選択してみましょう。',

      // 画像一覧画面
      _albumNotRegisterKey: '画像が登録されていません。\n「+」ボタンより画像を追加してみましょう。',

      // 画像プレビュー画面
      _photoPreviewTitleKey: '写真',
      _photoPreviewDeleteConfirmTitleKey: '確認',
      _photoPreviewDeleteConfirmMessageKey: 'この写真を削除します。よろしいですか？',

      // スケジュール確認画面
      _scheduleGroomTextKey: '新郎',
      _scheduleBrideTextKey: '新婦',

      // スケジュール登録画面
      _scheduleRegisterTitleKey: 'スケジュール登録',
      _scheduleNameLabelTextKey: 'お名前',
      _scheduleGroomNameLabelTextKey: '新郎お名前',
      _scheduleBrideNameLabelTextKey: '新婦お名前',
      _scheduleDateLabelTextKey: '日時',
      _scheduleDateSelectDescriptionKey: '日時を選択してください',
      _schedulePlaceLabelTextKey: '場所',
      _schedulePostalCodeSearchDescriptionKey: '郵便番号検索することで市町村までが住所に自動入力されます。',
      _schedulePostalCodeLabelTextKey: '郵便番号（ハイフンなし）',
      _scheduleAddressLabelTextKey: '住所',
      _scheduleRegisterConfirmMessageKey: 'スケジュールを登録します。よろしいですか？',

      // スケジュール切り替え画面
      _scheduleSelectTitleKey: '表示スケジュール切り替え',
      _scheduleSelectConfirmTitleKey: '確認',
      _scheduleSelectConfirmMessageKey: '選択したスケジュールを表示するよう切り替えます。\nよろしいですか？',

      // 参加者一覧画面
      _participantsEmptyErrorMessageKey: '参加者がおりません。',
      _deleteParticipantConfirmTitleKey: '確認',
      _deleteParticipantConfirmMessageKey:
          '選択したユーザーをこのスケジュールから削除します。\nよろしいですか？',

      // 参加者追加画面
      _addParticipantSuggestMessageKey: 'メールアドレスからユーザーを検索しましょう。',
      _notFountEmailAddressUserMessageKey:
          'ユーザーが見つかりません。\n（既に参加されている方や自分自身は表示されません。）',
      _addParticipantErrorTitle: '追加エラー',

      // 設定画面
      _userTitleKey: 'ユーザー',
      _logoutTitleKey: 'ログアウト',
      _logoutMessageKey: 'ログアウトしますか？',
      _licenseTitleKey: 'ライセンス',
      _versionTitleKey: 'バージョン',

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
      _unableSearchAddressErrorMessageKey:
          '住所から検索した位置情報が取得できません。\n正しい住所を入力の上、もう一度お試し下さい。',
      _overDailyLimitErrorKey: '検索回数が上限に達しています。',
      _requestDeniedErrorKey: 'リクエストが拒否されました。',
      _invalidRequestErrorKey: '無効なリクエストです。',
      _notExistDataErrorMessageKey: 'データが存在しません。',
      _notExistUserDataErrorMessageKey: 'ユーザーデータが存在しません。',
      _notExistScheduleDataErrorMessageKey: 'スケジュールデータが存在しません。',
      _notExistEntryScheduleErrorMessageKey: '参加しているスケジュールがありません。',
      _noSelectScheduleErrorMessageKey:
          '表示するスケジュールが選択されていません。\nスケジュールの「+」ボタンから\nスケジュールを登録するか、\n設定の「表示するスケジュールを切り替え」で\n表示するスケジュールを選択して下さい。',
      _uploadImageErrorTitleKey: 'アップロードエラー',
      _uploadImageErrorMessageKey: '写真のアップロードに失敗しました。しばらくしてから、もう一度お試し下さい。',
      _permissionErrorTitleKey: '権限エラー',
      _photoPermissionDeniedErrorMessageKey:
          'アプリから写真へのアクセスができません。スマートフォンの設定から本アプリの写真のアクセスを許可して下さい。',
      _photoPermissionPermanentlyDeniedErrorMessageKey:
          'アプリから写真へのアクセスができません。スマートフォンの設定から本アプリの写真のアクセスを許可して下さい。',
      _timeoutErrorMessageKey: 'タイムアウトしました。\nしばらくしてから、もう一度お試し下さい。',
      _badRequestErrorMessageKey: '通信に失敗しました。\nエラーコード:401',
      _notFoundErrorMessageKey: '通信に失敗しました。\nエラーコード:404',
      _methodNotAllowErrorMessageKey: '通信に失敗しました。\nエラーコード:405',
      _httpErrorMessageKey: '通信に失敗しました。接続状態をご確認の上、もう一度お試し下さい。',
      _socketErrorMessageKey: '通信に失敗しました。接続状態をご確認の上、もう一度お試し下さい。',
      _networkErrorMessageKey: '通信に失敗しました。接続状態をご確認の上、もう一度お試し下さい。',
      _unLoginErrorMessageKey: '未ログイン状態です。再度ログインして下さい。',
      _generalErrorMessageKey: 'エラーが発生しました。\nしばらくしてからもう一度お試し下さい。',

      _reloadMessageKey: '再読み込み',
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
  String get resetPasswordSuccessMessage =>
      _getText(_resetPasswordSuccessMessageKey);

  String get homeTitle => _getText(_homeTitleKey);
  String get scheduleTitle => _getText(_scheduleTitleKey);
  String get settingTitle => _getText(_settingTitleKey);
  String get introductionTitle => _getText(_introductionTitleKey);
  String get introductionMessage => _getText(_introductionMessageKey);
  String get dearNewPairTitle => _getText(_dearNewPairTitleKey);
  String get dearNewPairMessage => _getText(_dearNewPairMessageKey);
  String get dearOrdinaryPersonTitle => _getText(_dearOrdinaryPersonTitleKey);
  String get dearOrdinaryPersonMessage =>
      _getText(_dearOrdinaryPersonMessageKey);

  String get albumNotRegisterMessage => _getText(_albumNotRegisterKey);

  String get photoPreviewTitle => _getText(_photoPreviewTitleKey);
  String get photoPreviewDeleteConfirmTitle =>
      _getText(_photoPreviewDeleteConfirmTitleKey);
  String get photoPreviewDeleteConfirmMessage =>
      _getText(_photoPreviewDeleteConfirmMessageKey);

  String get scheduleGroomText => _getText(_scheduleGroomTextKey);
  String get scheduleBrideText => _getText(_scheduleBrideTextKey);

  String get scheduleRegisterTitle => _getText(_scheduleRegisterTitleKey);
  String get scheduleNameLabelText => _getText(_scheduleNameLabelTextKey);
  String get scheduleGroomNameLabelText =>
      _getText(_scheduleGroomNameLabelTextKey);
  String get scheduleBrideNameLabelText =>
      _getText(_scheduleBrideNameLabelTextKey);
  String get scheduleDateLabelText => _getText(_scheduleDateLabelTextKey);
  String get scheduleDateSelectDescription =>
      _getText(_scheduleDateSelectDescriptionKey);
  String get schedulePlaceLabelText => _getText(_schedulePlaceLabelTextKey);
  String get schedulePostalCodeSearchDescription =>
      _getText(_schedulePostalCodeSearchDescriptionKey);
  String get schedulePostalCodeLabelText =>
      _getText(_schedulePostalCodeLabelTextKey);
  String get scheduleAddressLabelText => _getText(_scheduleAddressLabelTextKey);
  String get scheduleRegisterConfirmMessage =>
      _getText(_scheduleRegisterConfirmMessageKey);

  String get scheduleSelectTitle => _getText(_scheduleSelectTitleKey);
  String get scheduleSelectConfirmTitle =>
      _getText(_scheduleSelectConfirmTitleKey);
  String get scheduleSelectConfirmMessage =>
      _getText(_scheduleSelectConfirmMessageKey);

  String get participantsEmptyErrorMessage =>
      _getText(_participantsEmptyErrorMessageKey);
  String get deleteParticipantTitle =>
      _getText(_deleteParticipantConfirmTitleKey);
  String get deleteParticipantMessage =>
      _getText(_deleteParticipantConfirmMessageKey);

  String get addParticipantSuggestMessage =>
      _getText(_addParticipantSuggestMessageKey);
  String get notFoundEmailAddressUserMessage =>
      _getText(_notFountEmailAddressUserMessageKey);
  String get addParticipantErrorTitle => _getText(_addParticipantErrorTitle);

  String get userTitle => _getText(_userTitleKey);
  String get logoutTitle => _getText(_logoutTitleKey);
  String get logoutMessage => _getText(_logoutMessageKey);
  String get licenseTitle => _getText(_licenseTitleKey);
  String get versionTitle => _getText(_versionTitleKey);

  String get warningEmptyMessage => _getText(_warningEmptyMessageKey);

  String get connectionErrorTitle => _getText(_connectionErrorTitleKey);
  String get inputFormErrorTitle => _getText(_inputFormErrorTitleKey);
  String get generalErrorTitle => _getText(_generalErrorTitleKey);

  String get emptyError => _getText(_emptyErrorMessageKey);
  String get invalidEmailError => _getText(_invalidEmailErrorMessageKey);
  String get alreadyUsedEmailError =>
      _getText(_emailAlreadyUsedErrorMessageKey);
  String get wrongPasswordError => _getText(_wrongPasswordErrorMessageKey);
  String get weakPasswordError => _getText(_weakPasswordErrorMessageKey);
  String get userNotFoundError => _getText(_userNotFoundErrorMessageKey);
  String get userDisabledError => _getText(_userDisabledErrorMessageKey);
  String get invalidCredentialError =>
      _getText(_invalidCredentialErrorMessageKey);
  String get tooManyRequestsError => _getText(_tooManyRequestsErrorMessageKey);
  String get unselectDateError => _getText(_unSelectDateErrorMessageKey);
  String get invalidPostalCodeError =>
      _getText(_invalidPostalCodeErrorMessageKey);
  String get unableSearchAddressError =>
      _getText(_unableSearchAddressErrorMessageKey);
  String get overDailyLimitError => _getText(_overDailyLimitErrorKey);
  String get requestDeniedError => _getText(_requestDeniedErrorKey);
  String get invalidRequestError => _getText(_invalidRequestErrorKey);
  String get notExistDataError => _getText(_notExistDataErrorMessageKey);
  String get notExistUserDataError =>
      _getText(_notExistUserDataErrorMessageKey);
  String get notExistScheduleDataError =>
      _getText(_notExistScheduleDataErrorMessageKey);
  String get notExistEntryScheduleError =>
      _getText(_notExistEntryScheduleErrorMessageKey);
  String get noSelectScheduleError =>
      _getText(_noSelectScheduleErrorMessageKey);
  String get uploadImageErrorTitle => _getText(_uploadImageErrorTitleKey);
  String get uploadImageError => _getText(_uploadImageErrorMessageKey);
  String get permissionErrorTitle => _getText(_permissionErrorTitleKey);
  String get photoPermissionDeniedError =>
      _getText(_photoPermissionDeniedErrorMessageKey);
  String get photoPermissionPermanentlyDeniedError =>
      _getText(_photoPermissionPermanentlyDeniedErrorMessageKey);
  String get timeoutError => _getText(_timeoutErrorMessageKey);
  String get badRequestError => _getText(_badRequestErrorMessageKey);
  String get notFoundError => _getText(_notFoundErrorMessageKey);
  String get methodNotAllowError => _getText(_methodNotAllowErrorMessageKey);
  String get httpError => _getText(_httpErrorMessageKey);
  String get socketError => _getText(_socketErrorMessageKey);
  String get networkError => _getText(_networkErrorMessageKey);
  String get unloginError => _getText(_unLoginErrorMessageKey);
  String get generalError => _getText(_generalErrorMessageKey);

  String get reloadMessage => _getText(_reloadMessageKey);
  String get defaultPositiveButtonTitle =>
      _getText(_defaultPositiveButtonTitleKey);
  String get defaultNegativeButtonTitle =>
      _getText(_defaultNegativeButtonTitleKey);
}
