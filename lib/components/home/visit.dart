import 'package:pandemia/data/database/models/Location.dart';

///Classe representant un lieux visite

class Visit {
  //localisation du lieu
  Location visit;
  //duree pendant laquelle l'utilisateur est rester dans cette location
  int nombre;



  Visit(Location l, int nb){
    this.visit = l;
    this.nombre = nb;
  }



}