/// Simple container for popularity statistics.
/// The "times" property contains hour <=> popularity associations:
/// e.g.: [15, 42] means that popularity equals 42% at 3pm.
/// On some days, places could be closed and thus not have statistics, hence the
/// "containsData" property.
class DayResult {
  List<List<int>> times;
  bool containsData;

  DayResult({this.times, this.containsData});
}