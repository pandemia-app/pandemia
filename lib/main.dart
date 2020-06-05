import 'package:flutter/material.dart';
import 'package:pandemia/data/database/database.dart';
import 'package:pandemia/data/database/models/Location.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pandemia/navigator.dart';
import 'package:provider/provider.dart';
import 'data/state/AppModel.dart';
import 'package:geolocator/geolocator.dart';

var geolocator = Geolocator();
var locationOptions = LocationOptions(accuracy: LocationAccuracy.best, timeInterval: 60000);
final AppDatabase db = new AppDatabase();

void main() async {
  await DotEnv().load('lib/.env.generated');
  db.open();

  // subscribing to location updates
  geolocator.getPositionStream(locationOptions).listen((Position position) {
    if (position == null) return;
    var loc = new Location(id: 0, lat: position.latitude, lng: position.longitude,
        timestamp: position.timestamp);
    db.insertLocation(loc).then((_) => print('new location stored: $loc'));
  });

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
