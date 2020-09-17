import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/data/database/indicatorsComputer.dart';

void main() {
  IndicatorsComputer _computer;

  test('computer has not generated any report at creation', () {
    _computer = new IndicatorsComputer();
    expect(_computer.generated, false);
  });

  /*
  test('computer can store a report for today', () {
    var computer = new IndicatorsComputer();
    int today = DailyReport.getTodaysTimestamp();
  });
   */
}
