import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/routes.dart';
import 'package:inbear_app/view/screen/home_page.dart';
import 'package:inbear_app/view/screen/login_page.dart';
import 'package:inbear_app/view/screen/register_page.dart';
import 'package:inbear_app/view/screen/splash_page.dart';
import 'package:provider/provider.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
  );

  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

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
      ],
      child: InbearApp(),
    )
  );
}

class InbearApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'inbear',
      routes: <String, WidgetBuilder> {
        Routes.SplashPagePath: (_) => SplashPage(),
        Routes.LoginPagePath: (_) => LoginPage(),
        Routes.RegisterPagePath: (_) => RegisterPage(),
        Routes.HomePagePath: (_) => HomePage(),
      },
      theme: ThemeData(
        primaryColor: Colors.pink[200],
        accentColor: Colors.pinkAccent
      ),
      initialRoute: Routes.LoginPagePath,
    );
  }
}