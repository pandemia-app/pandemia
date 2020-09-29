import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Locations gathered by the user's smartphone.
class Location {
  final int id;
  final double lat;
  final double lng;
  final DateTime timestamp;

  Location ({this.id, this.lat, this.lng, this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
      'date': timestamp.millisecondsSinceEpoch
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location (
      id: map['id'],
      lat: map['lat'],
      lng: map['lng'],
      timestamp: DateTime.fromMicrosecondsSinceEpoch(map['date'])
    );
  }

  @override
  String toString() {
    return '{lat: $lat, lng: $lng, date: $timestamp}';
  }

  LatLng toLatLng() {
    return LatLng(lat, lng);
  }
}