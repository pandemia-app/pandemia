import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/data/database/models/DailyReport.dart';

void main () {
  test("should not accept null exposition rate", () {
    expect(() {
      final DailyReport report =
        DailyReport(expositionRate: null, broadcastRate: 45, timestamp: 1);
    }, throwsAssertionError);
  });

  test("should not accept negative exposition rate", () {
    expect(() {
      final DailyReport report =
      DailyReport(expositionRate: -1, broadcastRate: 45, timestamp: 1);
    }, throwsAssertionError);
  });

  test("should not accept null broadcast rate", () {
    expect(() {
      final DailyReport report =
      DailyReport(expositionRate: 45, broadcastRate: null, timestamp: 1);
    }, throwsAssertionError);
  });

  test("should not accept negative broadcast rate", () {
    expect(() {
      final DailyReport report =
      DailyReport(expositionRate: 45, broadcastRate: -1, timestamp: 1);
    }, throwsAssertionError);
  });
}