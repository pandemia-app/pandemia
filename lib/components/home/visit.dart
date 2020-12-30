import 'package:pandemia/data/database/models/Location.dart';

class Visit {
  Location _visit;
  int _nombre;



  Visit(Location l, int nb){
    this.visit = l;
    this.nombre = nb;
  }

  Location get visit => _visit;

  set visit(Location value) {
    _visit = value;
  }

  int get nombre => _nombre;

  set nombre(int value) {
    _nombre = value;
  }


}