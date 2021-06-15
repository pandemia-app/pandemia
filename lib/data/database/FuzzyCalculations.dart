import 'Exposition.dart';
import 'Incidence.dart';
import 'NumberOfPlacesVisited.dart';
import 'Popularity.dart';
import 'TimeOfVisite.dart';
import 'package:fuzzylogic/fuzzylogic.dart';

class FuzzyCalculations {
  // since generateRandomReport is called several times (because of builds),
  // we need to be able to block further calls
  var generated = false;

  /// initialisation of variables
  var popularity = new Popularity();
  var timeofvisit = new TimeOfVisit();
  var placevisited = new NumberOfPlacesVisited();
  var incidence = new Incidence();
  var exposition = new Exposition();
  var myRules = new FuzzyRuleBase();

  ///define our fuzzy rules
  void addMyRules() {
    myRules.addRules([
      (popularity.crowded & placevisited.little) >> (exposition.medium),
      (popularity.crowded & placevisited.medium) >> (exposition.medium),
      (popularity.crowded & placevisited.lot) >> (exposition.strong),

      (popularity.medium & placevisited.little) >> (exposition.low),
      (popularity.medium & placevisited.medium) >> (exposition.medium),
      (popularity.medium & placevisited.lot) >> (exposition.strong),

      (popularity.empty & placevisited.little) >> (exposition.low),
      (popularity.empty & placevisited.medium) >> (exposition.medium),
      (popularity.empty & placevisited.lot) >> (exposition.strong),

      //////////////////////////////////////////////////////////

      (popularity.crowded & incidence.low) >> (exposition.low),
      (popularity.crowded & incidence.medium) >> (exposition.strong),
      (popularity.crowded & incidence.hight) >> (exposition.strong),

      (popularity.medium & incidence.low) >> (exposition.low),
      (popularity.medium & incidence.medium) >> (exposition.medium),
      (popularity.medium & incidence.hight) >> (exposition.strong),

      (popularity.empty & incidence.low) >> (exposition.low),
      (popularity.empty & incidence.medium) >> (exposition.low),
      (popularity.empty & incidence.hight) >> (exposition.medium),

      ////////////////////////////////////////////////////////////

      (popularity.crowded & timeofvisit.short) >> (exposition.medium),
      (popularity.crowded & timeofvisit.medium) >> (exposition.medium),
      (popularity.crowded & timeofvisit.long) >> (exposition.strong),

      (popularity.medium & timeofvisit.short) >> (exposition.low),
      (popularity.medium & timeofvisit.medium) >> (exposition.medium),
      (popularity.medium & timeofvisit.long) >> (exposition.strong),

      (popularity.empty & timeofvisit.short) >> (exposition.low),
      (popularity.empty & timeofvisit.medium) >> (exposition.low),
      (popularity.empty & timeofvisit.long) >> (exposition.medium),

      ////////////////////////////////////////////////////////
      /////////////////////INCIDENCE//////////////////////////
      ////////////////////////////////////////////////////////
      (incidence.hight & timeofvisit.short) >> (exposition.low),
      (incidence.hight & timeofvisit.medium) >> (exposition.strong),
      (incidence.hight & timeofvisit.long) >> (exposition.strong),

      (incidence.medium & timeofvisit.short) >> (exposition.low),
      (incidence.medium & timeofvisit.medium) >> (exposition.medium),
      (incidence.medium & timeofvisit.long) >> (exposition.strong),

      (incidence.low & timeofvisit.short) >> (exposition.low),
      (incidence.low & timeofvisit.medium) >> (exposition.low),
      (incidence.low & timeofvisit.long) >> (exposition.medium),

      ///////////////////////////////////////////////////////////

      (incidence.hight & placevisited.little) >> (exposition.low),
      (incidence.hight & placevisited.medium) >> (exposition.medium),
      (incidence.hight & placevisited.lot) >> (exposition.strong),

      (incidence.medium & placevisited.little) >> (exposition.low),
      (incidence.medium & placevisited.medium) >> (exposition.medium),
      (incidence.medium & placevisited.lot) >> (exposition.strong),

      (incidence.low & placevisited.little) >> (exposition.low),
      (incidence.low & placevisited.medium) >> (exposition.low),
      (incidence.low & placevisited.lot) >> (exposition.medium),

      ////////////////////////////////////////////////////////
      /////////////////////timeOfVisite//////////////////////////
      ////////////////////////////////////////////////////////

      (placevisited.lot & timeofvisit.short) >> (exposition.low),
      (placevisited.lot & timeofvisit.medium) >> (exposition.medium),
      (placevisited.lot & timeofvisit.long) >> (exposition.strong),

      (placevisited.medium & timeofvisit.short) >> (exposition.low),
      (placevisited.medium & timeofvisit.medium) >> (exposition.medium),
      (placevisited.medium & timeofvisit.long) >> (exposition.strong),

      (placevisited.little & timeofvisit.short) >> (exposition.low),
      (placevisited.little & timeofvisit.medium) >> (exposition.low),
      (placevisited.little & timeofvisit.long) >> (exposition.medium),

    ]);
  }
    /// aggregation and return final result
    int resolve(int _popularity , int _placevisited ,int _incidence,int _timeOfvisit) {
      var outPut = exposition.createOutputPlaceholder();
      myRules.resolve(
          inputs: [
            popularity.assign(_popularity),
            placevisited.assign(_placevisited),
            incidence.assign(_incidence),
            timeofvisit.assign(_timeOfvisit)
          ],
          outputs: [outPut]);

      return outPut.crispValue;
    }
  }

