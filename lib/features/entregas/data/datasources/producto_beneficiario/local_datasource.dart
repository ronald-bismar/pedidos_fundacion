import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/datasources/db_helper.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/producto_beneficiario.dart';
import 'package:sqflite/sqflite.dart';

final productBeneficiaryLocalDataSourceProvider =
    Provider<ProductBeneficiaryLocalDataSource>((ref) {
      final dbHelper = ref.watch(databaseHelperProvider);
      return ProductBeneficiaryLocalDataSource(dbHelper);
    });

class ProductBeneficiaryLocalDataSource {
  final DatabaseHelper _dbHelper;
  static const String tableName = 'product_beneficiary';

  ProductBeneficiaryLocalDataSource(this._dbHelper);

  static String createTable =
      'CREATE TABLE $tableName('
      'idProductoBeneficiario TEXT PRIMARY KEY, '
      'idBeneficio TEXT, '
      'estado TEXT, '
      'idEntregaBeneficiario TEXT '
      ')';

  Future<void> insert(ProductBeneficiary productBeneficiary) async {
    Database database = await _dbHelper.openDB();
    database.insert(
      tableName,
      productBeneficiary.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(ProductBeneficiary productBeneficiary) async {
    Database database = await _dbHelper.openDB();
    database.delete(
      tableName,
      where: 'idProductoBeneficiario = ?',
      whereArgs: [productBeneficiary.idProductoBeneficiario],
    );
  }

  Future<void> update(ProductBeneficiary productBeneficiary) async {
    Database database = await _dbHelper.openDB();
    await database.update(
      tableName,
      productBeneficiary.toMap(),
      where: 'idProductoBeneficiario = ?',
      whereArgs: [productBeneficiary.idProductoBeneficiario],
    );
  }

  Future<void> insertOrUpdate(
    List<ProductBeneficiary> productBeneficiaries,
  ) async {
    try {
      final Database db = await _dbHelper.openDB();
      Batch batch = db.batch();
      for (var item in productBeneficiaries) {
        batch.insert(
          tableName,
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      log('Error inserting ProductBeneficiary: $e');
    }
  }

  Future<ProductBeneficiary?> getProductBeneficiary(String id) async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'idProductoBeneficiario = ?',
      whereArgs: [id],
    );

    if (cMap.isNotEmpty) {
      return ProductBeneficiary.fromMap(cMap.first);
    }
    return null;
  }

  Future<List<ProductBeneficiary>> getAll() async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(tableName);

    return List.generate(
      cMap.length,
      (i) => ProductBeneficiary.fromMap(cMap[i]),
    );
  }

  Future<List<ProductBeneficiary>> getByBeneficio(String idBeneficio) async {
    Database database = await _dbHelper.openDB();
    final List<Map<String, dynamic>> cMap = await database.query(
      tableName,
      where: 'idBeneficio = ?',
      whereArgs: [idBeneficio],
    );

    return List.generate(
      cMap.length,
      (i) => ProductBeneficiary.fromMap(cMap[i]),
    );
  }
}
