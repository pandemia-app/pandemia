import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/data/database/models/DailyReport.dart';

void main () {
  test("should not accept null exposition rate", () {
    expect(() {
        DailyReport(expositionRate: null, broadcastRate: 45, timestamp: 1);
    }, throwsAssertionError);
  });

  test("should not accept negative exposition rate", () {
    expect(() {
      DailyReport(expositionRate: -1, broadcastRate: 45, timestamp: 1);
    }, throwsAssertionError);
  });

  test("should not accept null broadcast rate", () {
    expect(() {
      DailyReport(expositionRate: 45, broadcastRate: null, timestamp: 1);
    }, throwsAssertionError);
  });

  test("should not accept negative broadcast rate", () {
    expect(() {
      DailyReport(expositionRate: 45, broadcastRate: -1, timestamp: 1);
    }, throwsAssertionError);
  });

  test("should not accept null timestamp", () {
    expect(() {
      DailyReport(expositionRate: 45, broadcastRate: 42, timestamp: null);
    }, throwsAssertionError);
  });

  test("should not accept negative timestamp", () {
    expect(() {
      DailyReport(expositionRate: 45, broadcastRate: 42, timestamp: -5455286);
    }, throwsAssertionError);
  });

  test("should convert object to map", () {
    DailyReport report =
        DailyReport(timestamp: 1524856985, broadcastRate: 52, expositionRate: 5);
    Map<String, dynamic> map = report.toMap();

    expect(map.containsKey('id'), true);
    expect(map['id'], 1524856985);
    expect(map.containsKey('expositionRate'), true);
    expect(map['expositionRate'], 5);
    expect(map.containsKey('broadcastRate'), true);
    expect(map['broadcastRate'], 52);
  });
}