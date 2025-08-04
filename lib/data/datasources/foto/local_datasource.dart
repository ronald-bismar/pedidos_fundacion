import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/datasources/db_helper.dart';
import 'package:pedidos_fundacion/domain/entities/foto.dart';
import 'package:sqflite/sqflite.dart';

// Provider para PhotoDatasource (inyectando DatabaseHelper)
final photoLocalDataSourceProvider = Provider<PhotoLocalDataSource>((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return PhotoLocalDataSource(dbHelper);
});

class PhotoLocalDataSource {
  final DatabaseHelper _dbHelper;
  static const String tableName = 'photos';

  PhotoLocalDataSource(this._dbHelper);

  static String photos =
      'CREATE TABLE $tableName('
      'id TEXT PRIMARY KEY, '
      'name TEXT, '
      'urlRemote TEXT DEFAULT "", '
      'urlLocal TEXT DEFAULT ""'
      ')';

  Future<void> insert(Photo p) async {
    Database database = await _dbHelper.openDB();
    database.insert(
      tableName,
      p.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Photo>> list(String id) async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return List.generate(cMap.length, (i) => Photo.fromMap(cMap[i]));
  }

  Future<void> delete(Photo photo) async {
    Database database = await _dbHelper.openDB();
    database.delete(tableName, where: 'id = ?', whereArgs: [photo.id]);
  }

  Future<void> update(Photo photo) async {
    Database database = await _dbHelper.openDB();
    await database.insert(
      tableName,
      photo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertOrUpdate(List<Photo> photos) async {
    try {
      final Database db = await _dbHelper.openDB();
      Batch batch = db.batch();
      for (var m in photos) {
        batch.insert(
          tableName,
          m.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      log('Error inserting Photo: $e');
    }
  }
}
