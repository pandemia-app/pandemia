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
  int parser(String s){
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
  //print(len);
  int deg = len-1;
  while(j<len){
    res = res + pow(10,deg)*data[j];
    j++;
    deg--;
  }
  return res;

}
  Future<int> caculateExposition(BuildContext context) async {
    /// this function collects data and uses it as input for our fuzzy algorithm


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
  if(stats.currentPopularity != null){
    PopularityOfCurrentPlace = stats.currentPopularity;
  }

    /// get number of places visited
  int numberOfPlacesVisited = parser(visitedpalces.getPlacesTitle(context));
  print(numberOfPlacesVisited);
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
    /*
    fuzzyCalculations.addMyRules();
    int i = fuzzyCalculations.resolve(96,69,63,25);
    ///récuperation de la population d'un lieu
    String AddressOfUser = await locationOfUser.getAdress();
    String name = await locationOfUser.toString();
    Favorite placeWithStats = new Favorite(name: AddressOfUser, address: AddressOfUser);
    var stats = await Parser.getPopularTimes(placeWithStats);
    /// nombre de places visitées
    print('----------------');
    int numberOfPlacesVisited = parser(visitedpalces.getPlacesTitle(context));
    print(numberOfPlacesVisited);
    print('----------------');
*/

    //int resolve(int _popularity , int _placevisited ,int _incidence,int _timeOfvisit)
    // TODO rates computing

   // var p = new VisitedPlacesCard();
    //print("+++++++++++++++++++++++++");
    //var p = await _determinePosition();
    //print(p.longitude);
     //Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //print('----------------');
    //print(await locationOfUser.getAdress());
    //print('----------------');

    //Favorite placeWithStats = new Favorite(name: "jardin du luxembourg", address: "Paris, 75006, France");
    //var stats = await Parser.getPopularTimes(placeWithStats);
   // print(adress);
    //print(position.longitude);
    //print(position.latitude);

    //String z = "102366cvf";
    //print(parser(z)+2);
    //print(int.parse(p.getPlacesTitle(context)[0])+7);
    ////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////

    //print("currentPopularityOf eiffel Tower");
   // print('----------------');
   // print(stats.currentPopularity);
   // print('----------------');


   //print(stats.stats.values.first.containsData);
    //print("+++++++++++++++++++++++++");
    await new Future.delayed(const Duration(milliseconds: 750), () {});

    var report = new DailyReport(
        timestamp: DailyReport.getTodaysTimestamp(),
        broadcastRate: new Random().nextInt(100),
        expositionRate: await caculateExposition(context)//new Random().nextInt(100)
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
