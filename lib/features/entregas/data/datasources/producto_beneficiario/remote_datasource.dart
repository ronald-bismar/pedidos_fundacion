import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/di/services_provider.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/producto_beneficiario.dart';

final productBeneficiaryRemoteDataSourceProvider =
    Provider<ProductBeneficiaryRemoteDataSource>((ref) {
      final service = ref.watch(firestoreProvider);
      return ProductBeneficiaryRemoteDataSource(service);
    });

class ProductBeneficiaryRemoteDataSource {
  final FirebaseFirestore service;
  static const String _collection = 'productBeneficiary';

  ProductBeneficiaryRemoteDataSource(this.service);

  Future<void> insert(ProductBeneficiary productBeneficiary) async {
    try {
      await service
          .collection(_collection)
          .doc(productBeneficiary.idProductoBeneficiario)
          .set(productBeneficiary.toMap());
    } catch (e) {
      throw Exception('Error creating product beneficiary: $e');
    }
  }

  Future<void> delete(String productBeneficiaryId) async {
    try {
      await service.collection(_collection).doc(productBeneficiaryId).delete();
    } catch (e) {
      throw Exception('Error deleting product beneficiary: $e');
    }
  }

  Future<void> update(ProductBeneficiary productBeneficiary) async {
    try {
      await service
          .collection(_collection)
          .doc(productBeneficiary.idProductoBeneficiario)
          .update(productBeneficiary.toMap());
    } catch (e) {
      throw Exception('Error updating product beneficiary: $e');
    }
  }

  Future<ProductBeneficiary?> getProductBeneficiary(String id) async {
    try {
      final doc = await service.collection(_collection).doc(id).get();

      if (doc.exists && doc.data() != null) {
        log('Documento existe intentando mappear...');
        return ProductBeneficiary.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting product beneficiary by ID: $e');
    }
  }

  Future<List<ProductBeneficiary>> getAll() async {
    try {
      final querySnapshot = await service.collection(_collection).get();

      return querySnapshot.docs.map((doc) {
        return ProductBeneficiary.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error getting product beneficiaries: $e');
    }
  }

  Future<List<ProductBeneficiary>> getByBeneficio(String idBeneficio) async {
    try {
      final querySnapshot = await service
          .collection(_collection)
          .where('idBeneficio', isEqualTo: idBeneficio)
          .get();

      return querySnapshot.docs.map((doc) {
        return ProductBeneficiary.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error getting product beneficiaries by beneficio: $e');
    }
  }

  Future<List<ProductBeneficiary>> getByEstado(String estado) async {
    try {
      final querySnapshot = await service
          .collection(_collection)
          .where('estado', isEqualTo: estado)
          .get();

      return querySnapshot.docs.map((doc) {
        return ProductBeneficiary.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error getting product beneficiaries by estado: $e');
    }
  }
}
