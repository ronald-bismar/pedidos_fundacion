import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
      'idGroup TEXT, '
      'type TEXT, '
      'date TEXT, '
      'idMonthlyAttendance TEXT '
      ')';

  Future<void> insert(Attendance attendance) async {
    Database database = await _dbHelper.openDB();
    database.insert(
      tableName,
      attendance.toMap(),
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

  Future<Attendance?> getAttendanceByDate(String idGroup, DateTime date) async {
    Database database = await _dbHelper.openDB();

    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'idGroup = ? AND DATE(date) = DATE(?)',
      whereArgs: [idGroup, DateFormat('yyyy-MM-dd').format(date)],
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

   Future<List<Attendance>> getAttendanceOfMonth(String idMonthlyAttendance) async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'idMonthlyAttendance = ?',
      whereArgs: [idMonthlyAttendance],
    );

    return List.generate(cMap.length, (i) => Attendance.fromMap(cMap[i]));
  }
}
