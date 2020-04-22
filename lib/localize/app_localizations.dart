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
    },
  };

  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }
}