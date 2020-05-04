import 'package:pandemia/data/database/database.dart';
import 'package:pandemia/data/database/models/DailyReport.dart';
var database = new AppDatabase();

class IndicatorsComputer {
  Future<void> setTodaysReport (DailyReport report) async {
    // check if today's report exists
    var exists = await database.isReportRegistered(report.timestamp);

    // if not, insert the argument in db
    if (!exists) {
      await database.insertReport(report);
    }

    // if yes, update the report
    else {
      await database.updateExpositionRate(report);
    }
  }

  Future<bool> updateTodaysExpositionRate (int rate) async {
    // check if today's report exists
    var exists = await database.isReportRegistered(DailyReport.getTodaysTimestamp());
    if (!exists) return false;

    // if yes, update it
    await database.updateTodaysExpositionRate(rate);
    return true;
  }

  void updateTodaysBroadcastRate (int rate) async {
    // check if today's report exists
    // if not, create it
    // if yes, update it
  }
}