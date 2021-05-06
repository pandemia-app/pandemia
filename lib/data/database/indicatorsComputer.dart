import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:fuzzylogic/fuzzylogic.dart';
import 'package:pandemia/components/home/visitedPlacesCard.dart';
import 'package:pandemia/data/database/database.dart';
import 'package:pandemia/data/database/models/DailyReport.dart';
import 'package:pandemia/data/state/AppModel.dart';
import 'package:provider/provider.dart';
import '../populartimes/parser/parser.dart';
import 'Exposition.dart';
import 'Incidence.dart';
import 'PlaceVisited.dart';
import 'Popularity.dart';
import 'TimeOfVisite.dart';
import 'models/Favorite.dart';
import 'models/UserLocation.dart';

var database = new AppDatabase();
var locationOfUser = new UserLocation();
/// This is responsible for generating daily pandemia reports.
class IndicatorsComputer {
  // since generateRandomReport is called several times (because of builds),
  // we need to be able to block further calls
  var generated = false;
  /// initialisation of variables
  var popularity = new Popularity();
  var timeofvisit = new TimeOfVisit();
  var placevisited = new PlaceVisited();
  var incidence = new Incidence();
  var exposition = new Exposition();
  var myRules = new FuzzyRuleBase();
  ///define our fuzzy rules
    void addMyRules() {
    myRules.addRules([
      (popularity.strong & placevisited.low) >> (exposition.low),
      (popularity.strong & placevisited.medium) >> (exposition.medium),
      (popularity.strong & placevisited.strong) >> (exposition.strong),

      (popularity.medium & placevisited.low) >> (exposition.low),
      (popularity.medium & placevisited.medium) >> (exposition.medium),
      (popularity.medium & placevisited.strong) >> (exposition.strong),

      (popularity.low & placevisited.low) >> (exposition.low),
      (popularity.low & placevisited.medium) >> (exposition.low),
      (popularity.low & placevisited.strong) >> (exposition.low),

      //////////////////////////////////////////////////////////

      (popularity.strong & incidence.low) >> (exposition.low),
      (popularity.strong & incidence.medium) >> (exposition.strong),
      (popularity.strong & incidence.strong) >> (exposition.strong),

      (popularity.medium & incidence.low) >> (exposition.low),
      (popularity.medium & incidence.medium) >> (exposition.medium),
      (popularity.medium & incidence.strong) >> (exposition.strong),

      (popularity.low & incidence.low) >> (exposition.low),
      (popularity.low & incidence.medium) >> (exposition.low),
      (popularity.low & incidence.strong) >> (exposition.medium),

      ////////////////////////////////////////////////////////////

      (popularity.strong & timeofvisit.low) >> (exposition.low),
      (popularity.strong & timeofvisit.medium) >> (exposition.medium),
      (popularity.strong & timeofvisit.strong) >> (exposition.strong),

      (popularity.medium & timeofvisit.low) >> (exposition.low),
      (popularity.medium & timeofvisit.medium) >> (exposition.medium),
      (popularity.medium & timeofvisit.strong) >> (exposition.strong),

      (popularity.low & timeofvisit.low) >> (exposition.low),
      (popularity.low & timeofvisit.medium) >> (exposition.low),
      (popularity.low & timeofvisit.strong) >> (exposition.medium),

      ////////////////////////////////////////////////////////
      /////////////////////INCIDENCE//////////////////////////
      ////////////////////////////////////////////////////////
      (incidence.strong & timeofvisit.low) >> (exposition.low),
      (incidence.strong & timeofvisit.medium) >> (exposition.strong),
      (incidence.strong & timeofvisit.strong) >> (exposition.strong),

      (incidence.medium & timeofvisit.low) >> (exposition.low),
      (incidence.medium & timeofvisit.medium) >> (exposition.medium),
      (incidence.medium & timeofvisit.strong) >> (exposition.strong),

      (incidence.low & timeofvisit.low) >> (exposition.low),
      (incidence.low & timeofvisit.medium) >> (exposition.low),
      (incidence.low & timeofvisit.strong) >> (exposition.medium),

      ///////////////////////////////////////////////////////////

      (incidence.strong & placevisited.low) >> (exposition.low),
      (incidence.strong & placevisited.medium) >> (exposition.strong),
      (incidence.strong & placevisited.strong) >> (exposition.strong),

      (incidence.medium & placevisited.low) >> (exposition.low),
      (incidence.medium & placevisited.medium) >> (exposition.medium),
      (incidence.medium & placevisited.strong) >> (exposition.strong),

      (incidence.low & placevisited.low) >> (exposition.low),
      (incidence.low & placevisited.medium) >> (exposition.low),
      (incidence.low & placevisited.strong) >> (exposition.medium),

      ////////////////////////////////////////////////////////
      /////////////////////timeOfVisite//////////////////////////
      ////////////////////////////////////////////////////////

      (placevisited.strong & timeofvisit.low) >> (exposition.low),
      (placevisited.strong & timeofvisit.medium) >> (exposition.medium),
      (placevisited.strong & timeofvisit.strong) >> (exposition.strong),

      (placevisited.medium & timeofvisit.low) >> (exposition.low),
      (placevisited.medium & timeofvisit.medium) >> (exposition.medium),
      (placevisited.medium & timeofvisit.strong) >> (exposition.strong),

      (placevisited.low & timeofvisit.low) >> (exposition.low),
      (placevisited.low & timeofvisit.medium) >> (exposition.low),
      (placevisited.low & timeofvisit.strong) >> (exposition.medium),

    ]);
  }

 /// aggregation and return final result
  int resolve(){
    var outPut = exposition.createOutputPlaceholder();
    myRules.resolve(
        inputs: [popularity.assign(10), placevisited.assign(0),incidence.assign(53),timeofvisit.assign(9)],
        outputs: [outPut]);

    return outPut.crispValue;
  }



  double parser(String s){
  var data = new List(1000);
  int i = 0;
  int j = 0;
  double res = 0;
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






  /// is called several times a day to update today's report
  /// returns the exposition rate of the day
  Future<void> generateRandomReport (BuildContext context) async {
    if (generated) return;
    print('generating report');
    addMyRules();
    int i = resolve();
    // TODO rates computing

   // var p = new VisitedPlacesCard();
    print("+++++++++++++++++++++++++");
    //var p = await _determinePosition();
    //print(p.longitude);
     //Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    print(await locationOfUser.getAdress());

    //Favorite placeWithStats = new Favorite(name: "tour eiffel", address: "Paris, 75006, France");
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
    //print(stats.currentPopularity);


   //print(stats.stats.values.first.containsData);
    print("+++++++++++++++++++++++++");
    await new Future.delayed(const Duration(milliseconds: 750), () {});

    var report = new DailyReport(
        timestamp: DailyReport.getTodaysTimestamp(),
        broadcastRate: new Random().nextInt(100),
        expositionRate: i//new Random().nextInt(100)
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
