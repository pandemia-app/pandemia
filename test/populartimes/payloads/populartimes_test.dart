import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/data/populartimes/payloads/populartimes.dart';

void main() {
  PopularTimes _times;

  test("instance should not have data", () {
    _times = PopularTimes();
    expect(_times.hasData, false);
  });

  test("instance should have data", () {
    _times = PopularTimes(currentPopularity: 42, stats: Map());
    expect(_times.hasData, true);
  });

  test("instantiation is not possible when providing stats only", () {
    expect(() {
      PopularTimes(stats: Map());
    }, throwsAssertionError);
  });

  test("instantiation is not possible when providing popularity only", () {
    expect(() {
      PopularTimes(currentPopularity: 42);
    }, throwsAssertionError);
  });
}