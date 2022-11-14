import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dog.dart';

class DogRepository {
  late Future<Database>? database;

  Future<void> createDatabase() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'doggie_database.db'),
      onCreate: (db, version) {
        return db.execute('CREATE TABLE dogs (id INTEGER PRIMARY KEY, name TEXT, age INTEGER)');
      },
      version: 1
    );
  }

  Future<void> insertDog(Dog dog) async {
    if(database == null) throw Exception('database not created');
    final db = await database;
    await db!.insert(
        'dogs',
        dog.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<Dog>> dogs() async {
    if(database == null) throw Exception('database not created');
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('dogs');

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

  Future<void> updateDog(Dog dog) async {
    if(database == null) throw Exception('database not created');
    final db = await database;
    await db!.update(
      'dogs',
      dog.toMap(),
      where: 'id = ?',
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog(int id) async {
    if(database == null) throw Exception('database not created');
    final db = await database;
    await db!.delete(
        'dogs',
        where: 'id = ?',
        whereArgs: [id]
    );
  }
}