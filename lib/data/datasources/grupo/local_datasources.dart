import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/datasources/db_helper.dart';
import 'package:pedidos_fundacion/domain/entities/programa.dart';
import 'package:sqflite/sqflite.dart';

// Date for comparison example: SELECT * FROM coordinators WHERE updateAt > '2023-01-01T00:00:00Z'

final groupLocalDataSourceProvider = Provider<GroupLocalDataSource>((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return GroupLocalDataSource(dbHelper);
});

class GroupLocalDataSource {
  final DatabaseHelper _dbHelper;
  static const String tableName = 'groups';

  GroupLocalDataSource(this._dbHelper);

  static String groups =
      'CREATE TABLE $tableName('
      'id TEXT PRIMARY KEY, '
      'idTutor TEXT, '
      'groupName TEXT DEFAULT "", '
      'minAge INTEGER DEFAULT 0, '
      'maxAge INTEGER DEFAULT 0, '
      'updatedAt TEXT DEFAULT "" '
      ')';

  Future<void> insert(Group group) async {
    Database database = await _dbHelper.openDB();
    database.insert(
      tableName,
      group.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Group>> list(String id) async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return List.generate(cMap.length, (i) => Group.fromMap(cMap[i]));
  }

  Future<void> delete(String idGroup) async {
    Database database = await _dbHelper.openDB();
    database.delete(tableName, where: 'id = ?', whereArgs: [idGroup]);
  }

  Future<void> update(Group group) async {
    Database database = await _dbHelper.openDB();
    await database.insert(
      tableName,
      group.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertOrUpdate(List<Group> groups) async {
    try {
      final Database db = await _dbHelper.openDB();
      Batch batch = db.batch();
      for (var group in groups) {
        batch.insert(
          tableName,
          group.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      log('Error inserting Coordinator: $e');
    }
  }

  Future<Group?> getGroup(String id) async {
    log('Group id: $id');
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (cMap.isNotEmpty) {
      return Group.fromMap(cMap.first);
    }
    log('Map is empty returning null...');
    return null;
  }

  Future<void> updateRangeOfGroup(
    String idGroup,
    int minAge,
    int maxAge,
  ) async {
    try {
      Database database = await _dbHelper.openDB();
      await database.update(
        tableName,
        {
          'minAge': minAge,
          'maxAge': maxAge,
          'updatedAt': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [idGroup],
      );
      log('RangeAge updated locally for group: $idGroup');
    } catch (e) {
      log('Error updating RangeAge of group: $e');
    }
  }

  Future<Group?> getGroupByAge(int age) async {
    try {
      Database database = await _dbHelper.openDB();
      final List<Map<String, dynamic>> cMap = await database.query(
        tableName,
        where: 'minAge <= ? AND maxAge >= ?',
        whereArgs: [age, age],
        limit: 1,
      );

      if (cMap.isNotEmpty) {
        return Group.fromMap(cMap.first);
      }
      return null;
    } catch (e) {
      log('Error getting group by age: $age', error: e);
      return null;
    }
  }

  Future<List<Group>> getGroupsByAge(int age) async {
    try {
      Database database = await _dbHelper.openDB();
      final List<Map<String, dynamic>> cMap = await database.query(
        tableName,
        where: 'minAge <= ? AND maxAge >= ?',
        whereArgs: [age, age],
      );

      return List.generate(cMap.length, (i) => Group.fromMap(cMap[i]));
    } catch (e) {
      log('Error getting groups by age: $age', error: e);
      return [];
    }
  }

  Future<List<Group>> getAllGroups() async {
    try {
      Database database = await _dbHelper.openDB();
      final List<Map<String, dynamic>> cMap = await database.query(tableName);

      return List.generate(cMap.length, (i) => Group.fromMap(cMap[i]));
    } catch (e) {
      log('Error getting all groups', error: e);
      return [];
    }
  }

  Future<bool> hasGroupForAge(int age) async {
    try {
      if (age < 0) return false;

      Database database = await _dbHelper.openDB();
      final result = await database.query(
        tableName,
        columns: ['COUNT(*) as count'],
        where: 'minAge <= ? AND maxAge >= ?',
        whereArgs: [age, age],
      );

      return (result.first['count'] as int) > 0;
    } catch (e) {
      log('Error checking if group exists for age: $age', error: e);
      return false;
    }
  }

  Future<List<Group>> getGroupsByTutorId(String idTutor) async {
    try {
      Database database = await _dbHelper.openDB();
      final List<Map<String, dynamic>> cMap = await database.query(
        tableName,
        where: 'idTutor = ?',
        whereArgs: [idTutor],
      );

      return List.generate(cMap.length, (i) => Group.fromMap(cMap[i]));
    } catch (e) {
      log('Error getting groups by tutor id: $e', error: e);
      return [];
    }
  }
}
