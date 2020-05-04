import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/data/database/indicatorsComputer.dart';
import 'package:pandemia/data/database/models/DailyReport.dart';

void main() {
  testWidgets('Storing reports', (WidgetTester tester) async {
    var computer = new IndicatorsComputer();
    int today = DailyReport.getTodaysTimestamp();

    print('Adding a new report for today');
    await computer.setTodaysReport(
        new DailyReport(broadcastRate: 46, expositionRate: 58, timestamp: today)
    );
    var result = await database.isReportRegistered(today);
    expect(result, true);

    print('Updating exposition rate');
    var updateResult = await computer.updateTodaysExpositionRate(42);
    expect(updateResult, true);
    var report = await database.getReport(today);
    expect(report.expositionRate, 42);

    print('Updating broadcast rate');
    updateResult = false;
    updateResult = await computer.updateTodaysBroadcastRate(100);
    expect(updateResult, true);
    report = await database.getReport(today);
    expect(report.broadcastRate, 100);
  });
}
