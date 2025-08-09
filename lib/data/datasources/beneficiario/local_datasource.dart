import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/mappers/beneficiario_mapper.dart';
import 'package:pedidos_fundacion/data/datasources/db_helper.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';
import 'package:sqflite/sqflite.dart';

// Date for comparison example: SELECT * FROM coordinators WHERE updateAt > '2023-01-01T00:00:00Z'

final beneficiaryLocalDataSourceProvider = Provider<BeneficiaryLocalDataSource>(
  (ref) {
    final dbHelper = ref.watch(databaseHelperProvider);
    return BeneficiaryLocalDataSource(dbHelper);
  },
);

class BeneficiaryLocalDataSource {
  final DatabaseHelper _dbHelper;
  static const String tableName = 'beneficiaries';

  BeneficiaryLocalDataSource(this._dbHelper);

  static String beneficiaries =
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
      'code TEXT DEFAULT "", '
      'socialReasson TEXT DEFAULT "", '
      'idGroup TEXT DEFAULT "", '
      'birthdate TEXT DEFAULT ""'
      ')';

  Future<void> insert(Beneficiary c) async {
    Database database = await _dbHelper.openDB();
    database.insert(
      tableName,
      BeneficiaryMapper.toJson(c),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Beneficiary>> listByGroup(String idGroup) async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'idGroup = ?',
      whereArgs: [idGroup],
    );

    return List.generate(
      cMap.length,
      (i) => BeneficiaryMapper.fromJson(cMap[i]),
    );
  }

  Future<void> delete(Beneficiary beneficiary) async {
    Database database = await _dbHelper.openDB();
    database.delete(tableName, where: 'id = ?', whereArgs: [beneficiary.id]);
  }

  Future<void> update(Beneficiary beneficiary) async {
    Database database = await _dbHelper.openDB();
    await database.insert(
      tableName,
      BeneficiaryMapper.toJson(beneficiary),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertOrUpdate(List<Beneficiary> beneficiaries) async {
    try {
      final Database db = await _dbHelper.openDB();
      Batch batch = db.batch();
      for (var m in beneficiaries) {
        batch.insert(
          tableName,
          BeneficiaryMapper.toJson(m),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      log('Error inserting Beneficiary: $e');
    }
  }

  Future<Beneficiary?> getBeneficiary(String id) async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (cMap.isNotEmpty) {
      return BeneficiaryMapper.fromJson(cMap.first);
    }
    return null;
  }

  // Método privado que hace el trabajo real
  Future<bool> updateLocationAndPhone(
    String beneficiaryId,
    String location,
    String phone,
  ) async {
    try {
      Database database = await _dbHelper.openDB();
      await database.update(
        tableName,
        {
          'location': location,
          'phone': phone,
          'updateAt': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [beneficiaryId],
      );
      log('Location updated locally for beneficiary: $beneficiaryId');
      return true;
    } catch (e) {
      log('Error updating beneficiary location: $e');
      return false;
    }
  }

  void updateActive(Beneficiary beneficiary) {
    _updateActiveAsync(beneficiary.id, beneficiary.active).catchError((error) {
      log('Error updating beneficiary active locally: $error');
    });
  }

  Future<void> _updateActiveAsync(String beneficiaryId, bool active) async {
    try {
      Database database = await _dbHelper.openDB();
      await database.update(
        tableName,
        {'active': active, 'updateAt': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [beneficiaryId],
      );
      log('Active updated locally for beneficiary: $beneficiaryId');
    } catch (e) {
      log('Error updating beneficiary active: $e');
      // No throw Exception aquí - solo log
    }
  }

  Future<bool> existByDni(String dni) async {
    final Database database = await _dbHelper.openDB();
    final result = await database.query(
      tableName,
      columns: ['dni'],
      where: 'dni = ?',
      whereArgs: [dni],
      limit: 1, // Solo necesitas saber si existe al menos uno
    );
    return result.isNotEmpty;
  }
}
