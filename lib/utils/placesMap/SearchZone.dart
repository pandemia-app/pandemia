import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CircularSearchZone {
  final LatLng center;
  final double radius;

  CircularSearchZone({
    @required this.center, @required this.radius
  }) : assert(center != null),
       assert(radius != null),
       assert(radius >= 0);

  /// Checks if the viewport can be used.
  bool isValid () {
    return radius != 0.0;
  }

  @override
  String toString() {
    return "CircularSearchZone(center: $center, radius: $radius)";
  }
}