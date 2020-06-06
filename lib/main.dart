import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:inbear_app/api/address_search_api.dart';
import 'package:inbear_app/api/geocode_api.dart';
import 'package:inbear_app/datasource/image_datasource.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/localize/app_localizations_delegate.dart';
import 'package:inbear_app/localize/fallback_cupertino_localizations_delegate.dart';
import 'package:inbear_app/repository/address_repository.dart';
import 'package:inbear_app/repository/image_repository.dart';
import 'package:inbear_app/repository/schedule_respository.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/routes.dart';
import 'package:inbear_app/view/screen/home_page.dart';
import 'package:inbear_app/view/screen/login_page.dart';
import 'package:inbear_app/view/screen/reset_password_page.dart';
import 'package:inbear_app/view/screen/schedule_register_page.dart';
import 'package:inbear_app/view/screen/splash_page.dart';
import 'package:inbear_app/view/screen/user_register_page.dart';
import 'package:provider/provider.dart';

void main() {
  final googleApiKey = '';
  if (googleApiKey.isEmpty) {
    throw Exception('Google API Key is empty.');
  }

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;
  final _addressSearchApi = AddressSearchApi();
  // TODO:APIKeyの切り替え
  final _geoCodeApi = GeoCodeApi(googleApiKey);
  final _imageDataSource = ImageDataSource(_firebaseStorage);

  runApp(
      // アプリ全体で必要なものをProvider.createで生成,
      // Provider.of　で使用したい時に呼び出す
      MultiProvider(
    providers: [
      Provider(
        create: (context) => UserRepository(_firebaseAuth, _firestore),
      ),
      Provider(
        create: (context) => ScheduleRepository(_firebaseAuth, _firestore),
      ),
      Provider(
        create: (context) => AddressRepository(_addressSearchApi, _geoCodeApi),
      ),
      Provider(
        create: (context) => ImageRepository(_imageDataSource),
      )
    ],
    child: InbearApp(),
  ));
}

class InbearApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).title,
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        const FallbackCupertinoLocationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ja'),
      ],
      routes: <String, WidgetBuilder>{
        Routes.splashPagePath: (_) => SplashPage(),
        Routes.loginPagePath: (_) => LoginPage(),
        Routes.resetPasswordPagePath: (_) => ResetPasswordPage(),
        Routes.registerPagePath: (_) => UserRegisterPage(),
        Routes.homePagePath: (_) => HomePage(),
        Routes.scheduleRegisterPagePath: (_) => ScheduleRegisterPage(),
      },
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
      initialRoute: Routes.splashPagePath,
    );
  }
}
