import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pandemia/data/database/database.dart';
import 'package:pandemia/data/database/indicatorsComputer.dart';
import 'package:pandemia/data/database/models/DailyReport.dart';

class MockDatabase extends Mock implements AppDatabase {}

void main() {
  IndicatorsComputer _computer;

  test('computer has not generated any report at creation', () {
    _computer = new IndicatorsComputer();
    expect(_computer.generated, false);
  });

  test("should save today's report", () async {
    final int timestamp = DailyReport.getTodaysTimestamp();
    final DailyReport report = DailyReport(
        timestamp: timestamp,
        broadcastRate: 42, expositionRate: 58
    );
    DailyReport savedReport;

    final _db = MockDatabase();
    when(_db.isReportRegistered(timestamp))
      .thenAnswer((_) async {
        return false;
    });
    when(_db.insertReport(report))
      .thenAnswer((_) async {
        savedReport = report;
        return report;
    });

    _computer = new IndicatorsComputer(database: _db);
    await _computer.setTodaysReport(report);
    expect(savedReport, report); // checking if saved report is the one sent
  });

  test("should update today's report", () async {
    final int timestamp = DailyReport.getTodaysTimestamp();
    final DailyReport
      report = DailyReport(
        timestamp: timestamp,
        broadcastRate: 42, expositionRate: 58
      ),
      report2 = DailyReport(
          timestamp: timestamp,
          broadcastRate: 45, expositionRate: 64
      );

    DailyReport todaysSavedReport;

    final _db = MockDatabase();
    when(_db.isReportRegistered(timestamp))
        .thenAnswer((_) async {
      return todaysSavedReport != null;
    });
    when(_db.insertReport(report))
        .thenAnswer((_) async {
      todaysSavedReport = report;
      return report;
    });
    when(_db.updateExpositionRate(report2))
      .thenAnswer((realInvocation) async {
       todaysSavedReport = report2;
    });

    _computer = new IndicatorsComputer(database: _db);
    await _computer.setTodaysReport(report);
    await _computer.setTodaysReport(report2);
    expect(todaysSavedReport, report2);
  });

  test("should update today's exposition rate", () async {
    final int timestamp = DailyReport.getTodaysTimestamp();
    final DailyReport report = DailyReport(
        timestamp: timestamp,
        broadcastRate: 42, expositionRate: 58
    );
    final newRate = 42;
    DailyReport savedReport;

    final _db = MockDatabase();
    when(_db.isReportRegistered(timestamp))
        .thenAnswer((_) async {
      return savedReport != null;
    });
    when(_db.insertReport(report))
        .thenAnswer((_) async {
      savedReport = report;
      return report;
    });
    when(_db.updateTodaysExpositionRate(newRate))
        .thenAnswer((realInvocation) async {
          savedReport = DailyReport(
            timestamp: savedReport.timestamp,
            expositionRate: newRate,
            broadcastRate: savedReport.broadcastRate
          );
    });

    _computer = new IndicatorsComputer(database: _db);
    await _computer.setTodaysReport(report);
    expect(await _computer.updateTodaysExpositionRate(newRate), true);
    expect(savedReport.expositionRate, newRate);
  });

  test("should not update today's exposition rate since report doesn't exist", () async {
    final newRate = 42;

    final _db = MockDatabase();
    when(_db.isReportRegistered(DailyReport.getTodaysTimestamp()))
        .thenAnswer((_) async => false);

    _computer = new IndicatorsComputer(database: _db);
    expect(await _computer.updateTodaysExpositionRate(newRate), false);
  });
}
