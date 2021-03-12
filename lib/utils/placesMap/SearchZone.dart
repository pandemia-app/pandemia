import 'package:google_maps_flutter/google_maps_flutter.dart';

class CircularSearchZone {
  final LatLng center;
  final double radius;

  CircularSearchZone({this.center, this.radius});

  /// Checks if the viewport can be used.
  bool isValid () {
    return center.longitude != 0.0 && center.latitude != 0.0 || radius != 0.0;
  }

  @override
  String toString() {
    return "CircularSearchZone(center: $center, radius: $radius)";
  }
}