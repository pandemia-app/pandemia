import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/utils/PlacesCounter.dart';

void main() {
  PlacesCounter counter;

  test("should be empty when created", () {
    counter = new PlacesCounter(placesCountTarget: 0);
    expect(counter.placesCountTarget, 0);
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

  // TODO add a test to check if the counter returns true at a certain point
}