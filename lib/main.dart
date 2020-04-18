import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inbear_app/routes.dart';
import 'package:inbear_app/view/screen/login_page.dart';
import 'package:inbear_app/view/screen/register_page.dart';
import 'package:inbear_app/view/screen/splash_page.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
  );

  runApp(InbearApp());
}

class InbearApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'inbear',
      routes: <String, WidgetBuilder> {
        Routes.SplashPagePath: (_) => SplashPage(),
        Routes.LoginPagePath: (_) => LoginPage(),
        Routes.RegisterPagePath: (_) => RegisterPage()
      },
      theme: ThemeData(
        primaryColor: Colors.pink[200],
        accentColor: Colors.pinkAccent
      ),
      home: LoginPage(),
    );
  }
}