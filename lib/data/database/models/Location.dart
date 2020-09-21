import 'package:flutter/cupertino.dart';

/// Locations gathered by the user's smartphone.
class Location {
  final int id;
  final double lat;
  final double lng;
  final int timestamp;

  Location ({
    @required this.id,
    @required this.lat,
    @required this.lng,
    @required this.timestamp
  }): assert(id != null),
      assert(id >= 0),
      assert(timestamp != null),
      assert(timestamp >= 0),
      assert(lat != null),
      assert(lng != null);

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
      'date': timestamp
    };
  }

  @override
  String toString() {
    return 'Location{id: $id, lat: $lat, lng: $lng, date: $timestamp}';
  }


}