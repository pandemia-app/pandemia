import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pandemia/utils/placesMap/SearchZone.dart';

void main() {
  CircularSearchZone _zone;
  test("should create a valid search zone", () {
    _zone = CircularSearchZone(
      center: LatLng(55.17, 3.14),
      radius: 5
    );
    expect(_zone.isValid(), true);
  });

  test("cannot be created with null parameters", () {
    expect(() {
      _zone = CircularSearchZone(center: null, radius: null);
    }, throwsAssertionError);
  });

  test("cannot be created with null center", () {
    expect(() {
      _zone = CircularSearchZone(center: null, radius: 42);
    }, throwsAssertionError);
  });

  test("cannot be created with null radius", () {
    expect(() {
      _zone = CircularSearchZone(center: LatLng(55.17, 3.14), radius: null);
    }, throwsAssertionError);
  });

  test("cannot be created with negative radius", () {
    expect(() {
      _zone = CircularSearchZone(center: LatLng(55.17, 3.14), radius: -5);
    }, throwsAssertionError);
  });

  test("should be valid with a 0 center", () {
    _zone = CircularSearchZone(center: LatLng(0, 0), radius: 6);
    expect(_zone.isValid(), true);
  });

  test("should not be valid with a 0 radius", () {
    _zone = CircularSearchZone(center: LatLng(56.64, 5.48), radius: 0);
    expect(_zone.isValid(), false);
  });

  test("should convert to string", () {
    _zone = CircularSearchZone(
        center: LatLng(55, 3),
        radius: 5
    );
    expect(_zone.toString(),
        "CircularSearchZone(center: LatLng(55.0, 3.0), radius: 5.0)");
  });
}