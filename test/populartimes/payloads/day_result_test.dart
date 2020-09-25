import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/data/populartimes/payloads/dayResults.dart';

void main() {
  DayResult _result;

  test("should instantiate", () {
    _result = DayResult(containsData: true, times: [[1, 5], [2, 15], [3, 57]]);
    expect(_result.containsData, true);
  });

  test("an instance not containing data should have its times "
      "filled with zeroes", () {
    expect(() {
      DayResult(containsData: false, times: [[1, 5], [2, 15], [3, 57]]);
    }, throwsAssertionError);
  });

  test("should instantiate with no-data", () {
    _result = DayResult(
        containsData: false,
        times: [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0]]);
    expect(_result.containsData, false);
  });
}