import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/di/services_provider.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/ayuda_economica.dart';

final financialAidRemoteDataSourceProvider =
    Provider<FinancialAidRemoteDataSource>((ref) {
      final service = ref.watch(firestoreProvider);
      return FinancialAidRemoteDataSource(service);
    });

class FinancialAidRemoteDataSource {
  final FirebaseFirestore service;
  static const String _collection = 'financialAid';

  FinancialAidRemoteDataSource(this.service);

  Future<void> insert(FinancialAid financialAid) async {
    try {
      await service
          .collection(_collection)
          .doc(financialAid.id)
          .set(financialAid.toMap());
    } catch (e) {
      throw Exception('Error creating financial aid: $e');
    }
  }

  Future<void> delete(String financialAidId) async {
    try {
      await service.collection(_collection).doc(financialAidId).delete();
    } catch (e) {
      throw Exception('Error deleting financial aid: $e');
    }
  }

  Future<void> update(FinancialAid financialAid) async {
    try {
      await service
          .collection(_collection)
          .doc(financialAid.id)
          .update(financialAid.toMap());
    } catch (e) {
      throw Exception('Error updating financial aid: $e');
    }
  }

  Future<FinancialAid?> getFinancialAid(String id) async {
    try {
      final doc = await service.collection(_collection).doc(id).get();

      if (doc.exists && doc.data() != null) {
        log('Documento existe intentando mappear...');
        return FinancialAid.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting financial aid by ID: $e');
    }
  }

  Future<List<FinancialAid>> getAll() async {
    try {
      final querySnapshot = await service.collection(_collection).get();

      return querySnapshot.docs.map((doc) {
        return FinancialAid.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error getting financial aids: $e');
    }
  }

  Future<List<FinancialAid>> getByBenefit(String idBenefit) async {
    try {
      final querySnapshot = await service
          .collection(_collection)
          .where('idBenefit', isEqualTo: idBenefit)
          .get();

      return querySnapshot.docs.map((doc) {
        return FinancialAid.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error getting financial aids by benefit: $e');
    }
  }

  Future<List<FinancialAid>> getByDeliveryBeneficiary(
    String idDeliveryBeneficiary,
  ) async {
    try {
      final querySnapshot = await service
          .collection(_collection)
          .where('idDeliveryBeneficiary', isEqualTo: idDeliveryBeneficiary)
          .get();

      return querySnapshot.docs.map((doc) {
        return FinancialAid.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception(
        'Error getting financial aids by delivery beneficiary: $e',
      );
    }
  }

  Future<List<FinancialAid>> getByState(String state) async {
    try {
      final querySnapshot = await service
          .collection(_collection)
          .where('state', isEqualTo: state)
          .get();

      return querySnapshot.docs.map((doc) {
        return FinancialAid.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error getting financial aids by state: $e');
    }
  }
}
