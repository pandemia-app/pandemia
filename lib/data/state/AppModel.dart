import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pandemia/data/database/database.dart';
import 'package:pandemia/data/database/models/DailyReport.dart';

/// Holds data to be shared across the entire application.
class AppModel extends ChangeNotifier {
  int tabIndex = 0;
  List<DailyReport> reports = [];
  List<Marker> visitedPlacesMarkers = [];
  AppDatabase database = new AppDatabase();
  static String apiKey = DotEnv().env['GMAPS_PLACES_API_KEY'];

  setTabIndex (int index) {
    this.tabIndex = index;
    notifyListeners();
  }

  storeReports (List<DailyReport> reports) {
    print('storing ${reports.length} reports in model');
    this.reports.clear();
    this.reports.addAll(reports);
    notifyListeners();
  }

  setVisitedPlacesMarkers (List<Marker> markers) {
    this.visitedPlacesMarkers = markers;
    notifyListeners();
  }
}