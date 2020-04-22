import 'package:flutter/material.dart';
import 'package:pandemia/data/database/models/Location.dart';
import 'package:pandemia/navigator.dart';
import 'package:provider/provider.dart';
import 'data/database/database.dart';
import 'data/state/AppModel.dart';
import 'package:geolocator/geolocator.dart';

var geolocator = Geolocator();
var locationOptions = LocationOptions(accuracy: LocationAccuracy.best, timeInterval: 5000);
final LocationsDatabase db = new LocationsDatabase();

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    db.open();
    geolocator.getPositionStream(locationOptions).listen((Position position) {
      if (position == null) return;
      var loc = new Location(id: 0, lat: position.latitude, lng: position.longitude,
          timestamp: position.timestamp.millisecondsSinceEpoch);
      db.insertLocation(loc).then((_) => print('new location stored: $loc'));
    });

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
