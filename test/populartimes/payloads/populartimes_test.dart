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
      7: DayResult(containsData: true, times: []),
      1: DayResult(containsData: true, times: []),
      2: DayResult(containsData: true, times: []),
      3: DayResult(containsData: true, times: []),
      4: DayResult(containsData: true, times: []),
      5: DayResult(containsData: true, times: []),
      6: DayResult(containsData: true, times: [])
    });
    expect(_times.getOrderedKeys(), [1,2,3,4,5,6,7]);
  });

  test("should throw when not having full week data", () {
    _times = PopularTimes(currentPopularity: 42, stats: {
      7: DayResult(containsData: true, times: []),
      1: DayResult(containsData: true, times: []),
      2: DayResult(containsData: true, times: []),
    });

    expect(() {
      _times.getOrderedKeys();
    }, throwsAssertionError);
  });

  test("should throw when containing incorrect data keys", () {
    _times = PopularTimes(currentPopularity: 42, stats: {
      8: DayResult(containsData: true, times: []),
      9: DayResult(containsData: true, times: []),
      20: DayResult(containsData: true, times: []),
      30: DayResult(containsData: true, times: []),
      40: DayResult(containsData: true, times: []),
      50: DayResult(containsData: true, times: []),
      60: DayResult(containsData: true, times: [])
    });
    expect(() {
      _times.getOrderedKeys();
    }, throwsAssertionError);
  });

  test("should convert to string", () {
    _times = PopularTimes(currentPopularity: 42, stats: {
      7: DayResult(containsData: true, times: []),
      1: DayResult(containsData: true, times: []),
      2: DayResult(containsData: true, times: []),
      3: DayResult(containsData: true, times: []),
      4: DayResult(containsData: true, times: []),
      5: DayResult(containsData: true, times: []),
      6: DayResult(containsData: true, times: [])
    });

    String expected = "PopularTimes[hasData=true, currentPopularity=42, stats={7: Instance of 'DayResult', 1: Instance of 'DayResult', 2: Instance of 'DayResult', 3: Instance of 'DayResult', 4: Instance of 'DayResult', 5: Instance of 'DayResult', 6: Instance of 'DayResult'}]";
    expect(_times.toString(), expected);
  });

  test("should convert no-data payload to string", () {
    _times = PopularTimes();
    expect(_times.toString(), "PopularTimes[hasData=false]");
  });
}