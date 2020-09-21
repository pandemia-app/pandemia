import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pandemia/utils/placesMap/SearchZone.dart';

void main() {
  test("should create a valid search zone", () {
    CircularSearchZone zone = CircularSearchZone(
      center: LatLng(55.17, 3.14),
      radius: 5
    );
    expect(zone.isValid(), true);
  });
}