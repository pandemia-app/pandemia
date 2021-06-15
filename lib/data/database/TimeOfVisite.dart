import 'package:fuzzylogic/fuzzylogic.dart';

class TimeOfVisit extends FuzzyVariable<int> {
  var short = new FuzzySet.LeftShoulder(0, 33, 66);
  var medium = new FuzzySet.Triangle(33, 50, 100);
  var long = new FuzzySet.RightShoulder(33, 100, 100);

  TimeOfVisit() {
    sets = [short, medium, long];
    init();
  }
}