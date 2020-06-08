import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_settings.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/data/database/database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pandemia/navigator.dart';
import 'package:pandemia/utils/geolocation/Geolocator.dart';
import 'package:provider/provider.dart';
import 'data/state/AppModel.dart';

final AppDatabase db = new AppDatabase();

void main() async {
  await DotEnv().load('lib/.env.generated');
  db.open();
  Geolocator.launch();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppModel(),
      child: MyApp(),
    ),
  );
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
