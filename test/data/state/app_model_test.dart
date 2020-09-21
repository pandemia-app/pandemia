import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/data/database/models/DailyReport.dart';
import 'package:pandemia/data/state/AppModel.dart';

void main() {
  AppModel _model;
  setUp(() {
    _model = AppModel();
  });

  test("should be initialised with default values", () {
    expect(_model.tabIndex, 0);
    expect(_model.reports, []);
  });

  test("should set tab index", () {
    expect(_model.tabIndex, 0);
    _model.setTabIndex(2);
    expect(_model.tabIndex, 2);
  });

  // there are only 3 tabs, index varies from 0 to 2 included
  test("should not set tab index", () {
    expect(() {
      _model.setTabIndex(3);
    }, throwsAssertionError);
  });

  test("should not set negative tab index", () {
    expect(() {
      _model.setTabIndex(-1);
    }, throwsAssertionError);
  });

  test("should not set null tab index", () {
    expect(() {
      _model.setTabIndex(null);
    }, throwsAssertionError);
  });

  test("should not store null reports", () {
    expect(() {
      _model.storeReports(null);
    }, throwsAssertionError);
  });

  test("should correctly store 0 reports", () {
    _model.storeReports([]);
    expect(_model.reports.length, 0);
  });

  test("should correctly store several reports", () {
    final List<DailyReport> reports = [
      DailyReport(timestamp: 1, broadcastRate: 1, expositionRate: 1),
      DailyReport(timestamp: 2, broadcastRate: 2, expositionRate: 2)
    ];

    _model.storeReports(reports);
    expect(_model.reports.length, 2);
    expect(_model.reports, reports);
  });

  test("should not set negative tab index", () {
    final List<DailyReport>
      oldReports = [
        DailyReport(timestamp: 1, broadcastRate: 1, expositionRate: 1),
        DailyReport(timestamp: 2, broadcastRate: 2, expositionRate: 2)
      ],
      newReports = [
        DailyReport(timestamp: 1, broadcastRate: 1, expositionRate: 1),
        DailyReport(timestamp: 2, broadcastRate: 2, expositionRate: 2),
        DailyReport(timestamp: 3, broadcastRate: 4, expositionRate: 7),
        DailyReport(timestamp: 4, broadcastRate: 45, expositionRate: 52),
      ];

    _model.storeReports(oldReports);
    expect(_model.reports, oldReports);

    _model.storeReports(newReports);
    expect(_model.reports, newReports);
  });

  test("should warn observers when changing tab index", () {
    int callCounts = 0;
    _model..addListener(() { callCounts += 1; });
    expect(callCounts, 0);

    _model.setTabIndex(2);
    expect(callCounts, 1);
  });

  test("should warn observers when storing reports", () {
    int callCounts = 0;
    _model..addListener(() { callCounts += 1; });
    expect(callCounts, 0);

    _model.storeReports([]);
    expect(callCounts, 1);
  });
}