

import 'package:fuzzylogic/fuzzylogic.dart';

class Exposition extends FuzzyVariable<int> {
  var low = new FuzzySet.LeftShoulder(0, 33, 66);
  var medium = new FuzzySet.Triangle(33,50,100);
  var strong = new FuzzySet.RightShoulder(33, 100, 100);

  Exposition() {
    sets = [low, medium, strong];
    init();
  }

}