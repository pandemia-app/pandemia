import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:pandemia/data/database/database.dart';
import 'package:pandemia/data/database/models/DailyReport.dart';
import 'package:pandemia/data/state/AppModel.dart';
import 'package:provider/provider.dart';
var database = new AppDatabase();

class IndicatorsComputer {
  /// is called several times a day to update today's report
  /// returns the exposition rate of the day
  Future<int> generateRandomReport (BuildContext context) async {
    // TODO rates computing

    var report = new DailyReport(
        timestamp: DailyReport.getTodaysTimestamp(),
        broadcastRate: new Random().nextInt(100),
        expositionRate: new Random().nextInt(100)
    );
    await setTodaysReport(report);

    // putting all reports in app model, to share them among other components
    List<DailyReport> reports = await database.getReports();
    if (reports.length != 0)
      Provider.of<AppModel>(context, listen: false).storeReports(reports);

    return report.expositionRate;
  }

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

  Future<bool> updateTodaysBroadcastRate (int rate) async {
    // check if today's report exists
    var exists = await database.isReportRegistered(DailyReport.getTodaysTimestamp());
    if (!exists) return false;

    // if yes, update it
    await database.updateTodaysBroadcastRate(rate);
    return true;
  }
}