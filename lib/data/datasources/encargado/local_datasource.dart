import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/mappers/encargado_mapper.dart';
import 'package:pedidos_fundacion/data/datasources/db_helper.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';
import 'package:sqflite/sqflite.dart';

// Date for comparison example: SELECT * FROM coordinators WHERE updateAt > '2023-01-01T00:00:00Z'

final localDataSourceProvider = Provider<CoordinatorLocalDatasource>((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return CoordinatorLocalDatasource(dbHelper);
});

class CoordinatorLocalDatasource {
  final DatabaseHelper _dbHelper;
  static const String tableName = 'coordinators';

  CoordinatorLocalDatasource(this._dbHelper);

  static String coordinators =
      'CREATE TABLE $tableName('
      'id TEXT PRIMARY KEY, '
      'dni TEXT, '
      'name TEXT DEFAULT "", '
      'lastName TEXT DEFAULT "", '
      'email TEXT DEFAULT "", '
      'idPhoto TEXT DEFAULT "", '
      'username TEXT DEFAULT "", '
      'password TEXT DEFAULT "", '
      'phone TEXT DEFAULT "", '
      'location TEXT DEFAULT "", '
      'updateAt TEXT DEFAULT "", '
      'active INTEGER DEFAULT 1, '
      'profession TEXT DEFAULT "", '
      'role TEXT DEFAULT ""'
      ')';

  Future<void> insert(Coordinator c) async {
    Database database = await _dbHelper.openDB();
    database.insert(
      tableName,
      CoordinatorMapper.toJson(c),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Coordinator>> list(String id) async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return List.generate(
      cMap.length,
      (i) => CoordinatorMapper.fromJson(cMap[i]),
    );
  }

  Future<void> delete(Coordinator coordinator) async {
    Database database = await _dbHelper.openDB();
    database.delete(tableName, where: 'id = ?', whereArgs: [coordinator.id]);
  }

  Future<void> update(Coordinator coordinator) async {
    Database database = await _dbHelper.openDB();
    await database.insert(
      tableName,
      CoordinatorMapper.toJson(coordinator),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertOrUpdate(List<Coordinator> coordinators) async {
    try {
      final Database db = await _dbHelper.openDB();
      Batch batch = db.batch();
      for (var m in coordinators) {
        batch.insert(
          tableName,
          CoordinatorMapper.toJson(m),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      log('Error inserting Coordinator: $e');
    }
  }

  Future<Coordinator?> getCoordinator(String id) async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (cMap.isNotEmpty) {
      return CoordinatorMapper.fromJson(cMap.first);
    }
    return null;
  }

  void updateLocation(Coordinator coordinator) {
    _updateLocationAsync(coordinator.id, coordinator.location).catchError((error) {
      log('Error updating coordinator location locally: $error');
    });
  }

  // Método privado que hace el trabajo real
  Future<void> _updateLocationAsync(
    String coordinatorId,
    String location,
  ) async {
    try {
      Database database = await _dbHelper.openDB();
      await database.update(
        tableName,
        {
          'location': location,
          'updateAt': DateTime.now()
              .toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [coordinatorId],
      );
      log('Location updated locally for coordinator: $coordinatorId');
    } catch (e) {
      log('Error updating coordinator location: $e');
      // No throw Exception aquí - solo log
    }
  }

   void updateActive(Coordinator coordinator) {
    _updateActiveAsync(coordinator.id, coordinator.location).catchError((
      error,
    ) {
      log('Error updating coordinator active locally: $error');
    });
  }

  // Método privado que hace el trabajo real
  Future<void> _updateActiveAsync(
    String coordinatorId,
    String location,
  ) async {
    try {
      Database database = await _dbHelper.openDB();
      await database.update(
        tableName,
        {'active': location, 'updateAt': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [coordinatorId],
      );
      log('Location updated locally for coordinator: $coordinatorId');
    } catch (e) {
      log('Error updating coordinator active: $e');
      // No throw Exception aquí - solo log
    }
  }
}
