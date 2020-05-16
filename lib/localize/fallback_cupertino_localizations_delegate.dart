import 'package:flutter/cupertino.dart';

class FallbackCupertinoLocationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<CupertinoLocalizations> old) => false;
}
