import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/Location.dart';

class LocationsDatabase {
  Database database;
  final String tName = "locations";

  Future<void> open () async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, 'locations.db');
    this.database = await openDatabase(path, version: 1, onCreate: (db, version) {
      print("creating locations table");
      return db.execute(
        "CREATE TABLE locations (id INTEGER PRIMARY KEY, lat REAL, lng REAL, date INTEGER)",
      );
    });
  }

  Future<void> insertLocation(Location loc) async {
    await this.database.insert(
      this.tName,
      loc.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Location>> getLocations() async {
    final List<Map<String, dynamic>> maps = await this.database.query(tName);
    return List.generate(maps.length, (i) {
      return Location(
        id: maps[i]['id'],
        lat: maps[i]['lat'],
        lng: maps[i]['lng'],
        timestamp: maps[i]['date']
      );
    });
  }
}