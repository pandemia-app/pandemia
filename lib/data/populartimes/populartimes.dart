class PopularTimes {
  Map<int, List<List<int>>> stats;
  int currentPopularity;

  PopularTimes ({this.stats, this.currentPopularity});

  List<List<int>> getTodaysStats () {
    return stats[DateTime.now().weekday];
  }

  List<int> getOrderedKeys() {
    assert (stats.keys.length == 7);
    return [1, 2, 3, 4, 5, 6, 7];
  }
}