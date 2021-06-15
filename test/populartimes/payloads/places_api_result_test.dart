import 'dart:convert';
import 'dart:io';

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

  test("should not instantiate with null placeId", () {
    expect(() {
      _result = PlacesAPIResult(placeId: null, location: LatLng(1, 2));
    }, throwsAssertionError);
  });

  test("should not instantiate with empty string as placeId", () {
    expect(() {
      _result = PlacesAPIResult(placeId: "", location: LatLng(1, 2));
    }, throwsAssertionError);
  });

  test("should not instantiate with null location", () {
    expect(() {
      _result = PlacesAPIResult(placeId: "placeId", location: null);
    }, throwsAssertionError);
  });

  test("should correctly built from Places API json", () async {
    String result =
      await new File('test/populartimes/payloads/api_response.json')
          .readAsString();
    dynamic decodedJson = jsonDecode(result);

    _result = PlacesAPIResult.fromJSON(decodedJson['results'][0]);
    expect(_result.placeId, "ChIJJf4E2GKM3EcRx2iWXnyL8mQ");
    expect(_result.location, LatLng(51.03259119999999, 2.3758071));
    expect(_result.name, "MONOPRIX");
    expect(_result.address, "9 Place de la République, Dunkerque");
  });
}