import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/datasources/db_helper.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/entrega_beneficiario.dart';
import 'package:sqflite/sqflite.dart';

final deliveryBeneficiaryLocalDataSourceProvider =
    Provider<DeliveryBeneficiaryLocalDataSource>((ref) {
      final dbHelper = ref.watch(databaseHelperProvider);
      return DeliveryBeneficiaryLocalDataSource(dbHelper);
    });

class DeliveryBeneficiaryLocalDataSource {
  final DatabaseHelper _dbHelper;
  static const String tableName = 'delivery_beneficiary';

  DeliveryBeneficiaryLocalDataSource(this._dbHelper);

  static String createTable =
      'CREATE TABLE $tableName('
      'id TEXT PRIMARY KEY, '
      'codeBeneficiary TEXT, '
      'nameBeneficiary TEXT, '
      'state TEXT, '
      'idPhotoDelivery TEXT, '
      'deliveryDate TEXT, '
      'updatedAt TEXT, '
      'idDelivery TEXT '
      ')';

  Future<void> insert(DeliveryBeneficiary deliveryBeneficiary) async {
    Database database = await _dbHelper.openDB();
    database.insert(
      tableName,
      deliveryBeneficiary.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(DeliveryBeneficiary deliveryBeneficiary) async {
    Database database = await _dbHelper.openDB();
    database.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [deliveryBeneficiary.id],
    );
  }

  Future<void> update(DeliveryBeneficiary deliveryBeneficiary) async {
    Database database = await _dbHelper.openDB();
    await database.update(
      tableName,
      deliveryBeneficiary.toMap(),
      where: 'id = ?',
      whereArgs: [deliveryBeneficiary.id],
    );
  }

  Future<void> insertOrUpdate(
    List<DeliveryBeneficiary> deliveryBeneficiaries,
  ) async {
    try {
      final Database db = await _dbHelper.openDB();
      Batch batch = db.batch();
      for (var item in deliveryBeneficiaries) {
        batch.insert(
          tableName,
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      log('Error inserting DeliveryBeneficiary: $e');
    }
  }

  Future<DeliveryBeneficiary?> getDeliveryBeneficiary(String id) async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (cMap.isNotEmpty) {
      return DeliveryBeneficiary.fromMap(cMap.first);
    }
    return null;
  }

  Future<List<DeliveryBeneficiary>> getAll() async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(tableName);

    return List.generate(
      cMap.length,
      (i) => DeliveryBeneficiary.fromMap(cMap[i]),
    );
  }

  Future<List<DeliveryBeneficiary>> getByDelivery(String idDelivery) async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'idDelivery = ?',
      whereArgs: [idDelivery],
    );

    return List.generate(
      cMap.length,
      (i) => DeliveryBeneficiary.fromMap(cMap[i]),
    );
  }
}
