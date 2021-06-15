import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/utils/PlacesCounter.dart';

void main() {
  PlacesCounter counter;

  test("should be empty when created", () {
    counter = new PlacesCounter(placesCountTarget: 1);
    expect(counter.placesCountTarget, 1);
    expect(counter.loadedPlaces, 0);
  });

  test("should be initialized with constructor value", () {
    counter = new PlacesCounter(placesCountTarget: 42);
    expect(counter.placesCountTarget, 42);
  });

  test("should increase internal state when calling addLoadedPlace", () {
    counter = new PlacesCounter(placesCountTarget: 5);
    expect(counter.loadedPlaces, 0);

    bool result = counter.addLoadedPlace();
    expect(result, false);
    expect(counter.loadedPlaces, 1);
  });

  test("should return true when objective is reached", () {
    final int target = 10;
    counter = new PlacesCounter(placesCountTarget: target);

    for (int i=0; i<target-1; i++) {
      bool result = counter.addLoadedPlace();
      expect(result, false);
    }

    expect(counter.addLoadedPlace(), true);
  });

  test("does not accept null as target", () {
    expect(() {
      counter = new PlacesCounter(placesCountTarget: null);
    }, throwsAssertionError);
  });

  test("does not accept 0 as target", () {
    expect(() {
      counter = new PlacesCounter(placesCountTarget: 0);
    }, throwsAssertionError);
  });

  test("does not accept negative values as target", () {
    expect(() {
      counter = new PlacesCounter(placesCountTarget: -42);
    }, throwsAssertionError);
  });
}