import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/datasources/db_helper.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/beneficio.dart';
import 'package:sqflite/sqflite.dart';

final benefitLocalDataSourceProvider = Provider<BenefitLocalDataSource>((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return BenefitLocalDataSource(dbHelper);
});

class BenefitLocalDataSource {
  final DatabaseHelper _dbHelper;
  static const String tableName = 'benefit';

  BenefitLocalDataSource(this._dbHelper);

  static String createTable =
      'CREATE TABLE $tableName('
      'id TEXT PRIMARY KEY, '
      'type TEXT, '
      'description TEXT, '
      'idDelivery TEXT, '
      'updatedAt TEXT '
      ')';

  Future<void> insert(Benefit benefit) async {
    Database database = await _dbHelper.openDB();
    database.insert(
      tableName,
      benefit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(Benefit benefit) async {
    Database database = await _dbHelper.openDB();
    database.delete(tableName, where: 'id = ?', whereArgs: [benefit.id]);
  }

  Future<void> update(Benefit benefit) async {
    Database database = await _dbHelper.openDB();
    await database.update(
      tableName,
      benefit.toMap(),
      where: 'id = ?',
      whereArgs: [benefit.id],
    );
  }

  Future<void> insertOrUpdate(List<Benefit> benefits) async {
    try {
      final Database db = await _dbHelper.openDB();
      Batch batch = db.batch();
      for (var item in benefits) {
        batch.insert(
          tableName,
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      log('Error inserting Benefit: $e');
    }
  }

  Future<Benefit?> getBenefit(String id) async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (cMap.isNotEmpty) {
      return Benefit.fromMap(cMap.first);
    }
    return null;
  }

  Future<List<Benefit>> getAll() async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(tableName);

    return List.generate(cMap.length, (i) => Benefit.fromMap(cMap[i]));
  }

  Future<List<Benefit>> getByDelivery(String idDelivery) async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'idDelivery = ?',
      whereArgs: [idDelivery],
    );

    return List.generate(cMap.length, (i) => Benefit.fromMap(cMap[i]));
  }
}
