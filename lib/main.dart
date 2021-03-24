import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pandemia/data/state/MapModel.dart';
import 'package:pandemia/views/home/navigator.dart';
import 'package:provider/provider.dart';
import 'data/state/AppModel.dart';
import 'package:intl/date_symbol_data_local.dart';


void main() async {
  await DotEnv().load('lib/.env.generated');
  await Firebase.initializeApp();
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runZonedGuarded<Future<void>>(() async {
    runApp(
      MultiProvider (
        providers: [
          ChangeNotifierProvider(create: (context) => AppModel()),
          ChangeNotifierProvider(create: (context) => MapModel())
        ],
        child: MyApp(),
      )
    );
  }, FirebaseCrashlytics.instance.recordError);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();

    return MaterialApp(
      title: 'Pandemia',
      home: MyHomePage(),
      localizationsDelegates: [
        FlutterI18nDelegate(
          translationLoader: FileTranslationLoader(
            useCountryCode: false,
          ),
        )
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  BottomNavigationWidgetState createState() => BottomNavigationWidgetState();
}
