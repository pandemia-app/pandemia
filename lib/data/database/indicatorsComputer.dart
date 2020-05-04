import 'package:pandemia/data/database/database.dart';
import 'package:pandemia/data/database/models/DailyReport.dart';
var database = new AppDatabase();

class IndicatorsComputer {
  void setTodaysReport (DailyReport report) async {
    // check if today's report exists
    var exists = await database.isReportRegistered(report.timestamp);

    // if not, insert the argument in db
    if (!exists) {
      database.insertReport(report);
    }

    // if yes, update the report
    else {

    }
  }

  void updateTodaysExpositionRate (int rate) async {
    // check if today's report exists
    // if not, create it
    // if yes, update it
  }

  void updateTodaysBroadcastRate (int rate) async {
    // check if today's report exists
    // if not, create it
    // if yes, update it
  }
}