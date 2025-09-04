import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/datasources/db_helper.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/entrega.dart';
import 'package:sqflite/sqflite.dart';

final deliveryLocalDataSourceProvider = Provider<DeliveryLocalDataSource>((
  ref,
) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return DeliveryLocalDataSource(dbHelper);
});

class DeliveryLocalDataSource {
  final DatabaseHelper _dbHelper;
  static const String tableName = 'delivery';

  DeliveryLocalDataSource(this._dbHelper);

  static String createTable =
      'CREATE TABLE $tableName('
      'id TEXT PRIMARY KEY, '
      'nameDelivery TEXT, '
      'deliveryDate TEXT, '
      'idGroup TEXT, '
      'nameGroup TEXT, '
      'foundation TEXT, '
      'updatedAt TEXT, '
      'type TEXT, '
      'idCoordinator TEXT '
      ')';

  Future<void> insert(Delivery delivery) async {
    Database database = await _dbHelper.openDB();
    database.insert(
      tableName,
      delivery.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(Delivery delivery) async {
    Database database = await _dbHelper.openDB();
    database.delete(tableName, where: 'id = ?', whereArgs: [delivery.id]);
  }

  Future<void> update(Delivery delivery) async {
    Database database = await _dbHelper.openDB();
    await database.update(
      tableName,
      delivery.toMap(),
      where: 'id = ?',
      whereArgs: [delivery.id],
    );
  }

  Future<void> insertOrUpdate(List<Delivery> deliveries) async {
    try {
      final Database db = await _dbHelper.openDB();
      Batch batch = db.batch();
      for (var item in deliveries) {
        batch.insert(
          tableName,
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      log('Error inserting Delivery: $e');
    }
  }

  Future<Delivery?> getDelivery(String id) async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (cMap.isNotEmpty) {
      return Delivery.fromMap(cMap.first);
    }
    return null;
  }

  Future<List<Delivery>> getAll() async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(tableName);

    return List.generate(cMap.length, (i) => Delivery.fromMap(cMap[i]));
  }

  Future<List<Delivery>> getByGroup(String idGroup) async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'idGroup = ?',
      whereArgs: [idGroup],
    );

    return List.generate(cMap.length, (i) => Delivery.fromMap(cMap[i]));
  }
}
