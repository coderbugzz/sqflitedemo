

import 'package:flutter/material.dart';

import '../page/demopage.dart';

void main() => runApp(MyDemoApp());


class MyDemoApp extends StatelessWidget
  {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        accentColor: Colors.cyan,
        fontFamily: 'Georgia',
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0,fontWeight: FontWeight.bold),
          headline2: TextStyle(fontSize: 36.0,fontStyle: FontStyle.italic),
          headline3: TextStyle(fontSize: 14.0, fontFamily: 'Hind')
        )),
        home: new Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('SQL Lite Demo App'),
          ),
          body: Container(
            margin: EdgeInsets.all(10.0),
            child: DemoPage(),
          ),
        ),
    );
  }
}