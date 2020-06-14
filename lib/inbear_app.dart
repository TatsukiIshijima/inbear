import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:inbear_app/api/address_search_api.dart';
import 'package:inbear_app/api/geocode_api.dart';
import 'package:inbear_app/api_keys.dart';
import 'package:inbear_app/datasource/image_datasource.dart';
import 'package:inbear_app/datasource/person_datasource.dart';
import 'package:inbear_app/flavor.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/localize/app_localizations_delegate.dart';
import 'package:inbear_app/localize/fallback_cupertino_localizations_delegate.dart';
import 'package:inbear_app/repository/address_repository.dart';
import 'package:inbear_app/repository/image_repository.dart';
import 'package:inbear_app/repository/schedule_respository.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/view/screen/splash_page.dart';
import 'package:provider/provider.dart';

class InbearApp extends StatelessWidget {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    final flavor = Provider.of<Flavor>(context);
    debugPrint('Flavor: $flavor');
    var googleApiKey = '';

    switch (flavor) {
      case Flavor.development:
        googleApiKey = ApiKeys.devGoogleApiKey;
        break;
      case Flavor.staging:
        googleApiKey = ApiKeys.stgGoogleApiKey;
        break;
      case Flavor.production:
        googleApiKey = ApiKeys.prodGoogleApiKey;
        break;
    }

    if (googleApiKey.isEmpty) {
      throw Exception('Google API Key is empty.');
    }

    final _addressSearchApi = AddressSearchApi();
    final _geoCodeApi = GeoCodeApi(googleApiKey);
    final _imageDataSource = ImageDataSource(_firebaseStorage);
    final _personDataSource = PersonDataSource();

    return MultiProvider(
      // アプリ全体で必要なものをProvider.createで生成,
      // Provider.of　で使用したい時に呼び出す
      providers: [
        Provider(
          create: (context) =>
              UserRepository(_firebaseAuth, _firestore, _personDataSource),
        ),
        Provider(
          create: (context) => ScheduleRepository(_firestore),
        ),
        Provider(
          create: (context) =>
              AddressRepository(_addressSearchApi, _geoCodeApi),
        ),
        Provider(
          create: (context) => ImageRepository(_imageDataSource),
        )
      ],
      child: MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context).title,
        localizationsDelegates: [
          const AppLocalizationsDelegate(),
          const FallbackCupertinoLocationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('ja'),
        ],
        theme: ThemeData(
            appBarTheme: AppBarTheme(
                iconTheme: IconThemeData(color: Colors.white),
                actionsIconTheme: IconThemeData(color: Colors.white),
                textTheme: TextTheme(
                    headline6: TextStyle(color: Colors.white, fontSize: 20))),
            primaryColor: Color(0xfff48fb1),
            primaryColorLight: Color(0xffffc1e3),
            primaryColorDark: Color(0xffbf5f82),
            secondaryHeaderColor: Color(0xffbf5f82),
            accentColor: Color(0xfff06292),
            cursorColor: Color(0xfff06292)),
        home: SplashPage(),
      ),
    );
  }
}
