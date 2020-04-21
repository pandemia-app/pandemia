import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocationsDatabase {
  Future<Database> database;

  Future<void> open () async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, 'locations.db');
    this.database = openDatabase(path, onCreate: (db, version) {
      print("creating locations table");
      return db.execute(
        "CREATE TABLE locations (coords LatLng, date Date)",
      );
    });
  }
}