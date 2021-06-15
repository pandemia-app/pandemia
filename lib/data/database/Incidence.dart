import 'package:fuzzylogic/fuzzylogic.dart';
class Incidence extends FuzzyVariable<int> {
  var low = new FuzzySet.LeftShoulder(0,33,66);
  var medium = new FuzzySet.Triangle(33, 50, 100);
  var hight = new FuzzySet.RightShoulder(33, 100, 100);

  Incidence() {
    sets = [low, medium, hight];
    init();
  }
}