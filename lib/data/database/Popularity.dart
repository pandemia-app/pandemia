
import 'package:fuzzylogic/fuzzylogic.dart';

class Popularity extends FuzzyVariable<int> {
  var empty = new FuzzySet.LeftShoulder(0, 33, 66);
  var medium = new FuzzySet.Triangle(33, 50,100);
  var crowded = new FuzzySet.RightShoulder(33,100,100);

  Popularity() {
    sets = [empty, medium, crowded];
    init();
  }
}