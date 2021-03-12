import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pandemia/data/state/MapModel.dart';
import 'package:pandemia/views/home/navigator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pandemia/utils/geolocation/Geolocator.dart';
import 'package:provider/provider.dart';
import 'data/state/AppModel.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await DotEnv().load('lib/.env.generated');
  await Firebase.initializeApp();
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runZoned<Future<void>>(() async {
  // checking location permission + status before launching location gathering
  Permission.locationAlways.status.then((permissionStatus) {
    if (permissionStatus.isGranted) {
      Permission.locationAlways.serviceStatus.then((serviceStatus) {
        if (serviceStatus.isEnabled) {
          Geolocator.launch();
        }
      });
    }
  });

  runApp(
      MultiProvider (
        providers: [
          ChangeNotifierProvider(create: (context) => AppModel()),
          ChangeNotifierProvider(create: (context) => MapModel())
        ],
        child: MyApp(),
      )
    );
  }, onError: FirebaseCrashlytics.instance.recordError);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();

    return MaterialApp(
      title: 'Pandemia',
      home: MyHomePage(),
      localizationsDelegates: [
        FlutterI18nDelegate(
          translationLoader: FileTranslationLoader(
            useCountryCode: false
          )
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
