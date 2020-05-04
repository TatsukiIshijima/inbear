import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:inbear_app/api/address_search_api.dart';
import 'package:inbear_app/api/geocode_api.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/localize/app_localizations_delegate.dart';
import 'package:inbear_app/localize/fallback_cupertino_localizations_delegate.dart';
import 'package:inbear_app/repository/address_repository.dart';
import 'package:inbear_app/repository/schedule_respository.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/routes.dart';
import 'package:inbear_app/view/screen/home_page.dart';
import 'package:inbear_app/view/screen/login_page.dart';
import 'package:inbear_app/view/screen/register_page.dart';
import 'package:inbear_app/view/screen/reset_password_page.dart';
import 'package:inbear_app/view/screen/schedule_register_page.dart';
import 'package:inbear_app/view/screen/splash_page.dart';
import 'package:provider/provider.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
  );

  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  final _addressSearchApi = AddressSearchApi();
  // TODO:APIKeyの切り替え
  final _geoCodeApi = GeoCodeApi('');

  runApp(
    // アプリ全体で必要なものをProvider.createで生成,
    // Provider.of　で使用したい時に呼び出す
    MultiProvider(
      providers: [
        Provider(
          create: (context) => UserRepository(
              _firebaseAuth,
              _firestore
          ),
        ),
        Provider(
          create: (context) => ScheduleRepository(
              _firebaseAuth,
              _firestore
          ),
        ),
        Provider(
          create: (context) => AddressRepository(
            _addressSearchApi,
            _geoCodeApi
          ),
        ),
      ],
      child: InbearApp(),
    )
  );
}

class InbearApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) => AppLocalizations.of(context).title,
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        const FallbackCupertinoLocationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ja'),
      ],
      routes: <String, WidgetBuilder> {
        Routes.SplashPagePath: (_) => SplashPage(),
        Routes.LoginPagePath: (_) => LoginPage(),
        Routes.ResetPasswordPagePath: (_) => ResetPasswordPage(),
        Routes.RegisterPagePath: (_) => RegisterPage(),
        Routes.HomePagePath: (_) => HomePage(),
        Routes.ScheduleRegisterPagePath: (_) => ScheduleRegisterPage(),
      },
      theme: ThemeData(
        primaryColor: Color(0xfff48fb1),
        primaryColorLight: Color(0xffffc1e3),
        primaryColorDark: Color(0xffbf5f82),
        secondaryHeaderColor: Color(0xffbf5f82),
        accentColor: Color(0xfff06292),
      ),
      initialRoute: Routes.SplashPagePath,
    );
  }
}