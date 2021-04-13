import 'package:fuzzylogic/fuzzylogic.dart';

class TimeOfVisit extends FuzzyVariable<int> {
  var low = new FuzzySet.LeftShoulder(0, 33, 66); //la valeur qu'on renvoie c'est 0 et si on dépasse 150 c'est null,25=peak
  var medium = new FuzzySet.Triangle(33, 50, 100);// pour le medium c'est entre 25 et 300 et peak = 150 et c'est la valeur qu'on renvoie.
  var strong = new FuzzySet.RightShoulder(33, 100, 100);//la valeur qu'on renvoie c'est 400 et si on met moins de 150 c'est null ,300=peak

  TimeOfVisit() {
    sets = [low, medium, strong];
    init();
  }
}