import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:inbear_app/flavor.dart';
import 'package:inbear_app/inbear_app.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(Provider<Flavor>.value(
    value: Flavor.development,
    child: InbearApp(),
  ));
}
