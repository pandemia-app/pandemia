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

  static int getTodaysTimestamp () {
    var now = DateTime.now();
    var date = DateTime(now.year, now.month, now.day);
    return date.millisecondsSinceEpoch;
  }
}