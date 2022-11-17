import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dog.dart';

class DogRepository {

  DogRepository._privateConstructor();
  static final DogRepository instance = DogRepository._privateConstructor();

  Database? _database;
  Future<Database> get database async {
    if(_database != null) return _database!;
    _database = await _createDatabase();
    return _database!;
  }

  _createDatabase() async{
    return openDatabase(
      join(await getDatabasesPath(), 'doggie_database.db'),
      onCreate: (db, version) {
        return db.execute('CREATE TABLE dogs (id INTEGER PRIMARY KEY, name TEXT, age INTEGER)');
      },
      version: 1
    );
  }

  Future<int> insertDogMap(Map<String, dynamic> dogMap) async {
    final db = await instance.database;
    return await db.insert(
      'dogs',
      dogMap,
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<Dog>> dogs() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('dogs');

    return List.generate(
        maps.length,
            (i) {
          return Dog(
            id: maps[i]['id'],
            name: maps[i]['name'],
            age: maps[i]['age'],
          );
        }
    );
  }

  Future<int> updateDogMap(Map<String, dynamic> dogMap) async {
    final db = await instance.database;
    return db.update(
      'dogs',
      dogMap,
      where: 'id = ?',
      whereArgs: [dogMap['id']],
    );
  }

  Future<int> saveDogMap(Map<String, dynamic> dogMap) async {
    return dogMap['id'] == null ? insertDogMap(dogMap) : updateDogMap(dogMap);
  }

  Future<int> deleteDog(int id) async {
    final db = await instance.database;
    return await db.delete(
        'dogs',
        where: 'id = ?',
        whereArgs: [id]
    );
  }
}