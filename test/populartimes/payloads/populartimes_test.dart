import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/data/populartimes/payloads/dayResults.dart';
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

  test("instantiation is not possible when popularity is null", () {
    expect(() {
      PopularTimes(stats: Map(), currentPopularity: null);
    }, throwsAssertionError);
  });

  test("instantiation is not possible when providing popularity only", () {
    expect(() {
      PopularTimes(currentPopularity: 42);
    }, throwsAssertionError);
  });

  test("should have data for the whole week", () {
    _times = PopularTimes(currentPopularity: 42, stats: {
      7: DayResult(),
      1: DayResult(),
      2: DayResult(),
      3: DayResult(),
      4: DayResult(),
      5: DayResult(),
      6: DayResult()
    });
    expect(_times.getOrderedKeys(), [1,2,3,4,5,6,7]);
  });

  test("should throw when not having full week data", () {
    _times = PopularTimes(currentPopularity: 42, stats: {
      7: DayResult(),
      1: DayResult(),
      2: DayResult(),
    });

    expect(() {
      _times.getOrderedKeys();
    }, throwsAssertionError);
  });

  test("should throw when containing incorrect data keys", () {
    _times = PopularTimes(currentPopularity: 42, stats: {
      8: DayResult(),
      9: DayResult(),
      20: DayResult(),
      30: DayResult(),
      40: DayResult(),
      50: DayResult(),
      60: DayResult()
    });
    expect(() {
      _times.getOrderedKeys();
    }, throwsAssertionError);
  });

  test("should convert to string", () {
    _times = PopularTimes(currentPopularity: 42, stats: {
      7: DayResult(),
      1: DayResult(),
      2: DayResult(),
      3: DayResult(),
      4: DayResult(),
      5: DayResult(),
      6: DayResult()
    });

    String expected = "PopularTimes[hasData=true, currentPopularity=42, stats={7: Instance of 'DayResult', 1: Instance of 'DayResult', 2: Instance of 'DayResult', 3: Instance of 'DayResult', 4: Instance of 'DayResult', 5: Instance of 'DayResult', 6: Instance of 'DayResult'}]";
    expect(_times.toString(), expected);
  });
}