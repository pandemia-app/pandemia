/// This counter allows places state to register a number a places, and to be
/// warned when all places signaled themselves as loaded.
class PlacesCounter {
  int placesCount = 0;
  int loadedPlaces = 0;

  /// Sets count to be reached by this counter.
  void setPlacesCount (int count) {
    placesCount = count;
  }

  /// Increments the current counter, and returns true if it corresponds to the
  /// objective counter.
  bool addLoadedPlace () {
    loadedPlaces += 1;
    return placesCount == loadedPlaces;
  }
}