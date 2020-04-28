import 'dart:async';
import 'package:pandemia/data/database/models/Favorite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/Location.dart';

class AppDatabase {
  Database database;
  final String lName = "locations";
  final String fName = "favorites";

  Future<void> open () async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, 'database.db');
    this.database = await openDatabase(path, version: 1, onCreate: (db, version) {
      print("creating db tables");
      db.execute(
        "CREATE TABLE $lName (id INTEGER PRIMARY KEY, lat REAL, lng REAL, date INTEGER)",
      );
      db.execute(
        "CREATE TABLE $fName (id INTEGER PRIMARY KEY, name TEXT, address TEXT)",
      );
    });
  }

  Future<void> insertLocation(Location loc) async {
    await this.database.insert(
      this.lName,
      loc.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertFavoritePlace(Favorite fav) async {
    if (this.database == null)
      await open();
    print('adding new place (${fav.id})');
    await this.database.insert(
      this.fName,
      fav.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Location>> getLocations() async {
    final List<Map<String, dynamic>> maps = await this.database.query(lName);
    return List.generate(maps.length, (i) {
      return Location(
        id: maps[i]['id'],
        lat: maps[i]['lat'],
        lng: maps[i]['lng'],
        timestamp: maps[i]['date']
      );
    });
  }

  Future<List<Favorite>> getFavoritePlaces() async {
    if (this.database == null)
      await open();

    final List<Map<String, dynamic>> maps = await this.database.query(fName);
    return List.generate(maps.length, (i) {
      return Favorite(
          id: maps[i]['id'],
          name: maps[i]['name'],
          address: maps[i]['address']
      );
    });
  }

  Future<void> removeFavoritePlace (int id) async {
    print('removing $id');
    if (this.database == null)
      await open();
    await database.delete( fName, where: "id = ?", whereArgs: [id]);
  }
}