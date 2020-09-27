import 'package:flutter/material.dart';
import 'widget/page1/page1_widget.dart';
import 'locator.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator(); // defendency injection paketi ayarlarını başlatma
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText1: TextStyle(
            fontFamily: 'Ubuntu',
            fontSize: 32,
            color: Colors.blue,
            fontWeight: FontWeight.w300,
          ),
          bodyText2: TextStyle(
            fontFamily: 'Ubuntu',
            fontSize: 24,
            color: Colors.blue,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      title: 'Smoke Counter',
      home: Page1Widget(),
    );
  }
}
