
import 'package:fuzzylogic/fuzzylogic.dart';

class PlaceVisited extends FuzzyVariable<int> {
  var little = new FuzzySet.LeftShoulder(0,33,66);
  var medium = new FuzzySet.Triangle(33, 50,83);
  var lot = new FuzzySet.RightShoulder(33, 100,100);

  PlaceVisited() {
    sets = [little, medium, lot];
    init();
  }
}