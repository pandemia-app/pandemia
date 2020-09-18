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
}
