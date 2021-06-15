import 'package:flutter/cupertino.dart';

/// This counter allows places state to register a number a places, and to be
/// warned when all places signaled themselves as loaded.
class PlacesCounter {
  final int placesCountTarget;
  int loadedPlaces = 0;

  PlacesCounter({
    @required this.placesCountTarget
  }) : assert(placesCountTarget != null),
       assert(placesCountTarget > 0);

  /// Increments the current counter, and returns true if it corresponds to the
  /// objective counter.
  bool addLoadedPlace () {
    loadedPlaces += 1;
    return placesCountTarget == loadedPlaces;
  }
}