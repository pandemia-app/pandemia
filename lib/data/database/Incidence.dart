import 'package:fuzzylogic/fuzzylogic.dart';
class Incidence extends FuzzyVariable<int> {
  var low = new FuzzySet.LeftShoulder(0, /*25*/33, /*150*/66); //la valeur qu'on renvoie c'est 0 et si on dépasse 150 c'est null,25=peak
  var medium = new FuzzySet.Triangle(/*25*/33, /*150*/50, /*300*/100);// pour le medium c'est entre 25 et 300 et peak = 150 et c'est la valeur qu'on renvoie.
  var strong = new FuzzySet.RightShoulder(/*150*/33, /*300*/100, /*400*/100);//la valeur qu'on renvoie c'est 400 et si on met moins de 150 c'est null ,300=peak

  Incidence() {
    sets = [low, medium, strong];
    init();
  }
}