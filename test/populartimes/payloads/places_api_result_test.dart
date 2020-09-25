import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pandemia/data/populartimes/payloads/PlacesAPIResult.dart';

void main() {
  PlacesAPIResult _result;
  test("should correctly instantiate", () {
    _result = PlacesAPIResult(placeId: "placeid", location: LatLng(1, 2));
    expect(_result.placeId, "placeid");
    expect(_result.location, LatLng(1, 2));
  });
}