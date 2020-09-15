import 'package:pandemia/data/populartimes/payloads/dayResults.dart';

/// Container for the popularity statistics data.
/// "hasData" property indicates if the place has statistics (some places do not,
/// cities for example).
class PopularTimes {
  bool hasData;
  Map<int, DayResult> stats;
  int currentPopularity;

  PopularTimes ({this.hasData, this.stats, this.currentPopularity});

  List<int> getOrderedKeys() {
    assert (stats.keys.length == 7);
    return [1, 2, 3, 4, 5, 6, 7];
  }

  @override
  String toString() {
    return "PopularTimes[hasData=$hasData, currentPopularity=$currentPopularity, stats=$stats]";
  }
}