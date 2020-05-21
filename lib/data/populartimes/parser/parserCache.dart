import 'package:pandemia/data/database/models/Favorite.dart';
import 'file:///C:/Users/remth/Travail/pandemia/lib/data/populartimes/payloads/populartimes.dart';

/// This cache is used by the popular times parser to avoid making HTTP calls
/// too often.
class ParserCache {
  Map<String, PopularTimes> statsCache = new Map();
  Map<String, DateTime> timesCache = new Map();

  /// Checks if the cache contains data that is fresh enough.
  bool hasStatsForPlace (Favorite place) {
    if (!statsCache.containsKey(place.id)) return false;
    if (isDataOutdated(place)) return false;
    return statsCache.containsKey(place.id);
  }

  /// Data is considered "outdated" if 120-or-more-seconds old
  bool isDataOutdated (Favorite place) {
    var now = DateTime.now();
    var statsTime = timesCache[place.id];
    var timeDelta = now.difference(statsTime);
    return timeDelta.inSeconds > 120;
  }

  PopularTimes getStatsFromPlace (Favorite place) {
    return statsCache[place.id];
  }

  /// Stores data for a given place. Also saves storage time.
  void storeStatsForPlace (Favorite place, PopularTimes stats) {
    statsCache[place.id] = stats;
    timesCache[place.id] = DateTime.now();
  }

  void clear () {
    print('clearing parser cache');
    statsCache.clear();
    timesCache.clear();
  }
}