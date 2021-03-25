import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pandemia/components/home/visit.dart';
import 'package:pandemia/data/database/database.dart';
import 'package:pandemia/data/database/models/DailyReport.dart';

/// Holds data to be shared across the entire application.
class AppModel extends ChangeNotifier {
  int tabIndex = 0;
  List<DailyReport> reports = [];
  List<Visit> visitedPlaces = [];
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

  setVisitedPlaces (List<Visit> places) {
    this.visitedPlaces = places;
    notifyListeners();
  }
}