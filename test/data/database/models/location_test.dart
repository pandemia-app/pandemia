import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/data/database/models/Location.dart';

void main () {
  test("shouldn't create a Location with null id", () {
    expect(() {
      Location(id: null, lat: 1, lng: 2, timestamp: 3);
    }, throwsAssertionError);
  });
  test("shouldn't create a Location with negative id", () {
    expect(() {
      Location(id: -1, lat: 1, lng: 2, timestamp: 3);
    }, throwsAssertionError);
  });

  test("shouldn't create a Location with null lat", () {
    expect(() {
      Location(id: 1, lat: null, lng: 2, timestamp: 3);
    }, throwsAssertionError);
  });

  test("shouldn't create a Location with null lng", () {
    expect(() {
      Location(id: 1, lat: 2, lng: null, timestamp: 3);
    }, throwsAssertionError);
  });

  test("shouldn't create a Location with null timestamp", () {
    expect(() {
      Location(id: 1, lat: 2, lng: 52, timestamp: null);
    }, throwsAssertionError);
  });
  test("shouldn't create a Location with negative timestamp", () {
    expect(() {
      Location(id: 1, lat: 2, lng: 52, timestamp: -425689125);
    }, throwsAssertionError);
  });
}