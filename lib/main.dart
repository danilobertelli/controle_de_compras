import 'package:controledecompras/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: Colors.deepOrangeAccent,
        primaryColor: Colors.deepOrange,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        buttonColor: Colors.orange,
        textTheme: TextTheme(
          bodyText1: TextStyle(fontSize: 14.0),
          button: TextStyle(fontSize: 14.0),
          subtitle1: TextStyle(fontSize: 20.0),
          caption: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
      home: SplashPage(),
    );
  }
}
