import 'package:flutter/cupertino.dart';

class VisitedPlacesComputer {
  static BuildContext _context;

  static init (BuildContext context) {
    _context = context;
    computeVisitedPlaces();
  }

  // TODO compute visited places and store them in AppModel
  static computeVisitedPlaces () {
    print("COMPUTING PLACES");
  }
}