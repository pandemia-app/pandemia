class PopularTimes {
  Map<int, List<List<int>>> stats;
  int currentPopularity;

  PopularTimes ({this.stats, this.currentPopularity});

  List<List<int>> getTodaysStats () {
    return stats[DateTime.now().weekday];
  }
}