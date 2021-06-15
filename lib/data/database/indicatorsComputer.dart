import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:fuzzylogic/fuzzylogic.dart';
import 'package:pandemia/components/home/visitedPlacesCard.dart';
import 'package:pandemia/data/database/database.dart';
import 'package:pandemia/data/database/models/DailyReport.dart';
import 'package:pandemia/data/state/AppModel.dart';
import 'package:provider/provider.dart';
import '../populartimes/parser/parser.dart';
import 'models/Favorite.dart';
import 'models/UserLocation.dart';
import 'FuzzyCalculations.dart';

var database = new AppDatabase();
var locationOfUser = new UserLocation();
var fuzzyCalculations=new FuzzyCalculations();
var visitedpalces = new VisitedPlacesCard();
/// This is responsible for generating daily pandemia reports.
class IndicatorsComputer {
  // since generateRandomReport is called several times (because of builds),
  // we need to be able to block further calls
  var generated = false;

  /// cast a string sentence into an integer
  /// exemple "12 places " => int 12
  int cast(String s){
  var data = new List(1000);
  int i = 0;
  int j = 0;
  int res = 0;
  while(int.tryParse(s[i]) is int){
    data[i] = int.tryParse(s[i]);
    i++;
  }
  int lastElement = data.last;
  int len = data.indexOf(lastElement);
  int deg = len-1;
  while(j<len){
    res = res + pow(10,deg)*data[j];
    j++;
    deg--;
  }
  return res;

}
  /// this function collects data and uses it as input for our fuzzy algorithm
  Future<int> caculateExposition(BuildContext context) async {
    ///get the popularity of the currente place
  String AddressOfUser = await locationOfUser.getAdress();
  String name = await locationOfUser.toString();
  int PopularityOfCurrentPlace = 0;
  /// icidence fixed to 51
  int incidence = 51;
  /// timeOfVisite fixed to 77
  int timeOfVisite = 77;
  Favorite placeWithStats = new Favorite(name: AddressOfUser, address: AddressOfUser);
  var stats = await Parser.getPopularTimes(placeWithStats);
  /// if the popularity is null it means that the place is closed we return 0
  if(stats.currentPopularity != null){
    PopularityOfCurrentPlace = stats.currentPopularity;
  }

    /// get number of places visited
  int numberOfPlacesVisited = cast(visitedpalces.getPlacesTitle(context));
  /// use our algorithm
  fuzzyCalculations.addMyRules();
  int expositionRate = fuzzyCalculations.resolve(PopularityOfCurrentPlace,numberOfPlacesVisited,incidence,timeOfVisite);
  return expositionRate;
}

  /// is called several times a day to update today's report
  /// returns the exposition rate of the day
  Future<void> generateRandomReport (BuildContext context) async {
    if (generated) return;
    print('generating report');
    await new Future.delayed(const Duration(milliseconds: 750), () {});

    var report = new DailyReport(
        timestamp: DailyReport.getTodaysTimestamp(),
        broadcastRate: new Random().nextInt(100),
        expositionRate: await caculateExposition(context)
    );
    await setTodaysReport(report);

    // putting all reports in app model, to share them among other components
    List<DailyReport> reports = await database.getReports();
    Provider.of<AppModel>(context, listen: false).storeReports(reports);

    generated = true;
  }

  Future<void> forceReportRecomputing (BuildContext context) async {
    generated = false;
    await generateRandomReport(context);
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
