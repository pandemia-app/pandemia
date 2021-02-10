import 'package:pandemia/data/database/models/Location.dart';

///Classe representant un lieux visite

class Visit {
  //localisation du lieu
  Location _visit;
  //duree pendant laquelle l'utilisateur est rester dans cette location
  int _nombre;



  Visit(Location l, int nb){
    this.visit = l;
    this.nombre = nb;
  }

  //methode permettant d'obtenir la location actuelle
  Location get visit => _visit;

  //methode permettant de modifier la location actuelle
  set visit(Location value) {
    _visit = value;
  }

  //methode permettant d'obtenir le nombre de minute durant lesquelles l'utilisateur est rester dans la location actuelle
  int get nombre => _nombre;

  //methode permettant de modifier le nombre de minute durant lesquelles l'utilisateur est rester dans la location actuelle
  set nombre(int value) {
    _nombre = value;
  }


}