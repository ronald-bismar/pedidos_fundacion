import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/datasources/db_helper.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/ayuda_economica.dart';
import 'package:sqflite/sqflite.dart';

final financialAidLocalDataSourceProvider =
    Provider<FinancialAidLocalDataSource>((ref) {
      final dbHelper = ref.watch(databaseHelperProvider);
      return FinancialAidLocalDataSource(dbHelper);
    });

class FinancialAidLocalDataSource {
  final DatabaseHelper _dbHelper;
  static const String tableName = 'financial_aid';

  FinancialAidLocalDataSource(this._dbHelper);

  static String financialAid =
      'CREATE TABLE $tableName('
      'id TEXT PRIMARY KEY, '
      'idBenefit TEXT, '
      'state TEXT, '
      'idDeliveryBeneficiary TEXT '
      ')';

  Future<void> insert(FinancialAid financialAid) async {
    Database database = await _dbHelper.openDB();
    database.insert(
      tableName,
      financialAid.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(FinancialAid financialAid) async {
    Database database = await _dbHelper.openDB();
    database.delete(tableName, where: 'id = ?', whereArgs: [financialAid.id]);
  }

  Future<void> update(FinancialAid financialAid) async {
    Database database = await _dbHelper.openDB();
    await database.update(
      tableName,
      financialAid.toMap(),
      where: 'id = ?',
      whereArgs: [financialAid.id],
    );
  }

  Future<void> insertOrUpdate(List<FinancialAid> financialAids) async {
    try {
      final Database db = await _dbHelper.openDB();
      Batch batch = db.batch();
      for (var item in financialAids) {
        batch.insert(
          tableName,
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      log('Error inserting FinancialAid: $e');
    }
  }

  Future<FinancialAid?> getFinancialAid(String id) async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (cMap.isNotEmpty) {
      return FinancialAid.fromMap(cMap.first);
    }
    return null;
  }

  Future<List<FinancialAid>> getAll() async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(tableName);

    return List.generate(cMap.length, (i) => FinancialAid.fromMap(cMap[i]));
  }

  Future<List<FinancialAid>> getByBenefit(String idBenefit) async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'idBenefit = ?',
      whereArgs: [idBenefit],
    );

    return List.generate(cMap.length, (i) => FinancialAid.fromMap(cMap[i]));
  }

  Future<List<FinancialAid>> getByDeliveryBeneficiary(
    String idDeliveryBeneficiary,
  ) async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'idDeliveryBeneficiary = ?',
      whereArgs: [idDeliveryBeneficiary],
    );

    return List.generate(cMap.length, (i) => FinancialAid.fromMap(cMap[i]));
  }
}
