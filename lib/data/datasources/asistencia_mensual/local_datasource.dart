import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pedidos_fundacion/data/datasources/db_helper.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia_mensual.dart';
import 'package:sqflite/sqflite.dart';

final monthlyAttendanceLocalDataSourceProvider =
    Provider<MonthlyAttendanceLocalDataSource>((ref) {
      final dbHelper = ref.watch(databaseHelperProvider);
      return MonthlyAttendanceLocalDataSource(dbHelper);
    });

class MonthlyAttendanceLocalDataSource {
  final DatabaseHelper _dbHelper;
  static const String tableName = 'monthly_attendance';

  MonthlyAttendanceLocalDataSource(this._dbHelper);

  static String monthlyAttendance =
      'CREATE TABLE $tableName('
      'id TEXT PRIMARY KEY, '
      'idGroup TEXT, '
      'nameGroup TEXT, '
      'month INTEGER, '
      'year INTEGER '
      ')';

  Future<void> insert(MonthlyAttendance c) async {
    Database database = await _dbHelper.openDB();
    database.insert(
      tableName,
      c.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(MonthlyAttendance attendance) async {
    Database database = await _dbHelper.openDB();
    database.delete(tableName, where: 'id = ?', whereArgs: [attendance.id]);
  }

  Future<void> update(MonthlyAttendance attendance) async {
    Database database = await _dbHelper.openDB();
    await database.update(
      tableName,
      attendance.toMap(),
      where: 'id = ?',
      whereArgs: [attendance.id],
    );
  }

  Future<void> insertOrUpdate(List<MonthlyAttendance> attendances) async {
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
      log('Error inserting MonthlyAttendance: $e');
    }
  }

  Future<MonthlyAttendance?> getAttendance(String id) async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (cMap.isNotEmpty) {
      return MonthlyAttendance.fromMap(cMap.first);
    }
    return null;
  }

  Future<MonthlyAttendance?> getAttendanceByDate(
    String idGroup,
    DateTime date,
  ) async {
    Database database = await _dbHelper.openDB();

    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'idGroup = ? AND DATE(date) = DATE(?)',
      whereArgs: [idGroup, DateFormat('yyyy-MM-dd').format(date)],
    );

    if (cMap.isNotEmpty) {
      return MonthlyAttendance.fromMap(cMap.first);
    }
    return null;
  }

  Future<List<MonthlyAttendance>> getAll() async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(tableName);

    return List.generate(
      cMap.length,
      (i) => MonthlyAttendance.fromMap(cMap[i]),
    );
  }
}
