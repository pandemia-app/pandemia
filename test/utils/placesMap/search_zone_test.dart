import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/utils/placesMap/SearchZone.dart';

void main() {
  test("should create a valid search zone", () {
    CircularSearchZone zone = CircularSearchZone();
    expect(zone.isValid(), true);
  });
}