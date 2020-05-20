import 'package:pandemia/data/populartimes/payloads/dayResults.dart';

class PopularTimes {
  Map<int, DayResult> stats;
  int currentPopularity;

  PopularTimes ({this.stats, this.currentPopularity});

  List<int> getOrderedKeys() {
    assert (stats.keys.length == 7);
    return [1, 2, 3, 4, 5, 6, 7];
  }
}