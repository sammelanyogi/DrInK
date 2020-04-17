import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:DrInK/models/jsonwater.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String waterTable = 'jsonTable';
  String colId = 'id';
String colJson = 'jsonWater';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // Stringis executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'jsonWater.db';

    // Open/create the database at a given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $waterTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colJson TEXT)');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getWaterMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $waterTable order by $colPriority ASC');
    var result = await db.query(waterTable, orderBy: '$colId ASC');
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertWater(WaterData water) async {
    Database db = await this.database;
    var result = await db.insert(waterTable, water.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateWater(WaterData water) async {
    var db = await this.database;
    var result = await db.update(waterTable, water.toMap(),
        where: '$colId = ?', whereArgs: [water.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteWater(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $waterTable WHERE $colId = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $waterTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<WaterData>> getWaterList() async {
    var noteMapList = await getWaterMapList(); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table

    List<WaterData> waterList = List<WaterData>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      waterList.add(WaterData.fromMapObject(noteMapList[i]));
    }

    return waterList;
  }
}
