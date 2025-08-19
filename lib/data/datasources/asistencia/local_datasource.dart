import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/datasources/db_helper.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia.dart';
import 'package:sqflite/sqflite.dart';

final attendanceLocalDataSourceProvider = Provider<AttendanceLocalDataSource>((
  ref,
) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return AttendanceLocalDataSource(dbHelper);
});

class AttendanceLocalDataSource {
  final DatabaseHelper _dbHelper;
  static const String tableName = 'attendance';

  AttendanceLocalDataSource(this._dbHelper);

  static String attendance =
      'CREATE TABLE $tableName('
      'id TEXT PRIMARY KEY, '
      'type TEXT, '
      'idGroup TEXT, '
      'nameGroup TEXT, '
      'date TEXT '
      ')';

  Future<void> insert(Attendance c) async {
    Database database = await _dbHelper.openDB();
    database.insert(
      tableName,
      c.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(Attendance attendance) async {
    Database database = await _dbHelper.openDB();
    database.delete(tableName, where: 'id = ?', whereArgs: [attendance.id]);
  }

  Future<void> update(Attendance attendance) async {
    Database database = await _dbHelper.openDB();
    await database.update(
      tableName,
      attendance.toMap(),
      where: 'id = ?',
      whereArgs: [attendance.id],
    );
  }

  Future<void> insertOrUpdate(List<Attendance> attendances) async {
    try {
      final Database db = await _dbHelper.openDB();
      Batch batch = db.batch();
      for (var m in attendances) {
        batch.insert(
          tableName,
          m.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      log('Error inserting Attendance: $e');
    }
  }

  Future<Attendance?> getAttendance(String id) async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (cMap.isNotEmpty) {
      return Attendance.fromMap(cMap.first);
    }
    return null;
  }

  Future<List<Attendance>> getAll() async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(tableName);

    return List.generate(cMap.length, (i) => Attendance.fromMap(cMap[i]));
  }
}
