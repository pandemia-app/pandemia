/// This entity is used to provide daily pandemia reports to the user.
/// It contains several rates that should help them to behave better.
class DailyReport {
  final int expositionRate;
  final int broadcastRate;
  final int timestamp;

  DailyReport ({this.expositionRate, this.broadcastRate, this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'id': timestamp,
      'expositionRate': expositionRate,
      'broadcastRate': broadcastRate
    };
  }

  /// Returns a timestamp for the current day.
  /// Only containing year, month and day data, it returns the same date time
  /// throughout the day.
  static int getTodaysTimestamp () {
    var now = DateTime.now();
    var date = DateTime(now.year, now.month, now.day);
    return date.millisecondsSinceEpoch;
  }

  @override
  String toString() {
    return 'DailyReport[timestamp=${new DateTime.fromMillisecondsSinceEpoch(timestamp).toIso8601String()}, '
        'expositionRate=$expositionRate, broadcastRate=$broadcastRate]';
  }
}