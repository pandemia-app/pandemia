import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pandemia/navigator.dart';
import 'package:provider/provider.dart';
import 'data/state/AppModel.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() {
  runZoned<Future<void>>(() async {
    runApp(
      ChangeNotifierProvider(
        create: (context) => AppModel(),
        child: MyApp(),
      ),
    );
  }, onError: Crashlytics.instance.recordError);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pandemia',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  BottomNavigationWidgetState createState() => BottomNavigationWidgetState();
}
