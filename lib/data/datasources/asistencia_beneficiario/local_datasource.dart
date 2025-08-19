import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/datasources/db_helper.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia_beneficiario.dart';
import 'package:sqflite/sqflite.dart';

final attendanceBeneficiaryLocalDataSourceProvider =
    Provider<AttendanceBeneficiaryLocalDataSource>((ref) {
      final dbHelper = ref.watch(databaseHelperProvider);
      return AttendanceBeneficiaryLocalDataSource(dbHelper);
    });

class AttendanceBeneficiaryLocalDataSource {
  final DatabaseHelper _dbHelper;
  static const String tableName = 'attendance_beneficiary';

  AttendanceBeneficiaryLocalDataSource(this._dbHelper);

  static String attendanceBeneficiary =
      'CREATE TABLE $tableName('
      'id TEXT PRIMARY KEY, '
      'nameBeneficiary TEXT DEFAULT "", '
      'idBeneficiary TEXT DEFAULT "", '
      'idAttendance TEXT DEFAULT "", '
      'state TEXT DEFAULT "" '
      ')';

  Future<void> insert(AttendanceBeneficiary c) async {
    Database database = await _dbHelper.openDB();
    database.insert(
      tableName,
      c.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(AttendanceBeneficiary attendanceBeneficiary) async {
    Database database = await _dbHelper.openDB();
    database.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [attendanceBeneficiary.id],
    );
  }

  Future<void> update(AttendanceBeneficiary attendanceBeneficiary) async {
    Database database = await _dbHelper.openDB();
    await database.update(
      tableName,
      attendanceBeneficiary.toMap(),
      where: 'id = ?',
      whereArgs: [attendanceBeneficiary.id],
    );
  }

  Future<void> insertOrUpdate(
    List<AttendanceBeneficiary> attendanceBeneficiaries,
  ) async {
    try {
      final Database db = await _dbHelper.openDB();
      Batch batch = db.batch();
      for (var m in attendanceBeneficiaries) {
        batch.insert(
          tableName,
          m.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      log('Error inserting AttendanceBeneficiary: $e');
    }
  }

  Future<AttendanceBeneficiary?> getAttendanceBeneficiary(String id) async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (cMap.isNotEmpty) {
      return AttendanceBeneficiary.fromMap(cMap.first);
    }
    return null;
  }

  Future<List<AttendanceBeneficiary>> listByAttendance(
    String idAttendance,
  ) async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'idAttendance = ?',
      whereArgs: [idAttendance],
    );

    return List.generate(
      cMap.length,
      (i) => AttendanceBeneficiary.fromMap(cMap[i]),
    );
  } //Despues hacer una agrupacion por el id beneficiario

}
