import 'package:pandemia/data/database/models/DailyReport.dart';

class IndicatorsComputer {
  void setTodaysReport () async {
    // check if today's report exists
    // if not, insert the argument in db
    // if yes, update the report
  }

  Future<DailyReport> getTodaysReport () async {

  }

  void updateTodaysExpositionRate () async {
    // check if today's report exists
    // if not, create it
    // if yes, update it
  }

  void updateTodaysBroadcastRate () async {
    // check if today's report exists
    // if not, create it
    // if yes, update it
  }
}