import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/data/database/indicatorsComputer.dart';
import 'package:pandemia/data/database/models/DailyReport.dart';

void main() {
  testWidgets('Storing reports', (WidgetTester tester) async {
    var computer = new IndicatorsComputer();
    int today = DailyReport.getTodaysTimestamp();

    await computer.setTodaysReport(
        new DailyReport(broadcastRate: 46, expositionRate: 58, timestamp: today)
    );

    print(await database.getReports());
    var result = await database.isReportRegistered(today);
    expect(result, true);
  });
}
