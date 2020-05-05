import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pandemia/data/database/database.dart';
import 'package:pandemia/data/database/models/DailyReport.dart';

class AppModel extends ChangeNotifier {
  int tabIndex = 0;
  List<DailyReport> reports = [];
  AppDatabase database = new AppDatabase();
  static String apiKey = DotEnv().env['GMAPS_PLACES_API_KEY'];

  setTabIndex (int index) {
    this.tabIndex = index;
    notifyListeners();
  }

  storeReports (List<DailyReport> reports) {
    this.reports.clear();
    this.reports.addAll(reports);
  }
}