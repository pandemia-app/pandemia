import 'package:pandemia/data/populartimes/payloads/dayResults.dart';

/// Container for the popularity statistics data.
/// "hasData" property indicates if the place has statistics (some places do not,
/// cities for example).
class PopularTimes {
  bool hasData;
  Map<int, DayResult> stats;
  int currentPopularity;

  PopularTimes ({
    this.stats,
    this.currentPopularity
  }) : assert(stats == null && currentPopularity == null || stats != null && currentPopularity != null) {
    this.hasData = stats != null && currentPopularity != null;
  }

  List<int> getOrderedKeys() {
    assert (stats.keys.length == 7);
    List<int> orderedDays = [1, 2, 3, 4, 5, 6, 7];
    for (int key in stats.keys) {
      assert(orderedDays.contains(key));
    }
    
    return orderedDays;
  }

  @override
  String toString() {
    return
      "PopularTimes[hasData=$hasData" +
          (hasData ?
            ", currentPopularity=$currentPopularity, stats=$stats]" :
            "]");
  }
}