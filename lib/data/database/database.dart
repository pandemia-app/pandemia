import 'dart:async';
import 'package:pandemia/data/database/models/DailyReport.dart';
import 'package:pandemia/data/database/models/Favorite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'models/Location.dart';

class AppDatabase {
  Database database;
  final String lName = "locations";
  final String fName = "favorites";
  final String rName = "reports";

  Future<void> open () async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, 'database.db');
    this.database = await openDatabase(path, version: 1, onCreate: (db, version) {
      print("creating db tables");
      db.execute(
        "CREATE TABLE $lName (id INTEGER PRIMARY KEY, lat REAL, lng REAL, date INTEGER)",
      );
      db.execute(
        "CREATE TABLE $fName (id TEXT, name TEXT, address TEXT)",
      );
      db.execute(
        "CREATE TABLE $rName (id INTEGER, expositionRate INTEGER, broadcastRate INTEGER)"
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

  Future<bool> isPlaceRegistered(String placeId) async {
    if (this.database == null)
      await open();
    var place =
      await this.database.rawQuery('SELECT * from $fName WHERE id = "$placeId";');
    return place.length == 0 ? false : true;
  }

  Future<bool> isReportRegistered(int timestamp) async {
    if (this.database == null)
      await open();
    var report =
        await this.database.rawQuery('SELECT from $rName WHERE id = $timestamp');
    return report.length == 0 ? false : true;
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

  Future<void> insertReport(DailyReport report) async {
    if (this.database == null)
      await open();
    print('saving new report');
    await this.database.insert(
      rName,
      report.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<void> updateTodaysExpositionRate (int rate) async {
    if (this.database == null)
      await open();

    var now = DailyReport.getTodaysTimestamp();
    var result =
      await this.database.rawQuery('SELECT from $rName WHERE id = $now');
    if (result.length == 0) return;

    var report = result.elementAt(0);
    report['expositionRate'] = rate;

    await this.database.update(
      rName,
      report,
      where: "id = ?",
      whereArgs: [now],
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

  Future<void> removeFavoritePlace (String id) async {
    print('removing $id');
    if (this.database == null)
      await open();
    await database.delete( fName, where: "id = ?", whereArgs: [id]);
  }
}