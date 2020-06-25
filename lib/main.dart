import 'package:flutter/material.dart';
import 'package:suflex/pages/landing.page.dart';
import 'package:suflex/pages/user.new.page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Suflex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LandingPage(),
      routes: <String, WidgetBuilder>{
        '/user-new': (BuildContext context) => new UserNewPage(),
      },
    );
  }
}
