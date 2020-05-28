class PlacesCounter {
  int placesCount = 0;
  int loadedPlaces = 0;

  void setPlacesCount (int count) {
    placesCount = count;
  }

  bool addLoadedPlace () {
    loadedPlaces += 1;
    return placesCount == loadedPlaces;
  }
}