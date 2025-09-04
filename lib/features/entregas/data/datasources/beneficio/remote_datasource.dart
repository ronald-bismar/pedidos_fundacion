import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/di/services_provider.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/beneficio.dart';

final benefitRemoteDataSourceProvider = Provider<BenefitRemoteDataSource>((
  ref,
) {
  final service = ref.watch(firestoreProvider);
  return BenefitRemoteDataSource(service);
});

class BenefitRemoteDataSource {
  final FirebaseFirestore service;
  static const String _collection = 'benefit';

  BenefitRemoteDataSource(this.service);

  Future<void> insert(Benefit benefit) async {
    try {
      await service
          .collection(_collection)
          .doc(benefit.id)
          .set(benefit.toMap());
    } catch (e) {
      throw Exception('Error creating benefit: $e');
    }
  }

  Future<void> delete(String benefitId) async {
    try {
      await service.collection(_collection).doc(benefitId).delete();
    } catch (e) {
      throw Exception('Error deleting benefit: $e');
    }
  }

  Future<void> update(Benefit benefit) async {
    try {
      await service
          .collection(_collection)
          .doc(benefit.id)
          .update(benefit.toMap());
    } catch (e) {
      throw Exception('Error updating benefit: $e');
    }
  }

  Future<Benefit?> getBenefit(String id) async {
    try {
      final doc = await service.collection(_collection).doc(id).get();

      if (doc.exists && doc.data() != null) {
        log('Documento existe intentando mappear...');
        return Benefit.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting benefit by ID: $e');
    }
  }

  Future<List<Benefit>> getAll() async {
    try {
      final querySnapshot = await service.collection(_collection).get();

      return querySnapshot.docs.map((doc) {
        return Benefit.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error getting benefits: $e');
    }
  }

  Future<List<Benefit>> getByDelivery(String idDelivery) async {
    try {
      final querySnapshot = await service
          .collection(_collection)
          .where('idDelivery', isEqualTo: idDelivery)
          .get();

      return querySnapshot.docs.map((doc) {
        return Benefit.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error getting benefits by delivery: $e');
    }
  }

  Future<List<Benefit>> getByType(String type) async {
    try {
      final querySnapshot = await service
          .collection(_collection)
          .where('type', isEqualTo: type)
          .get();

      return querySnapshot.docs.map((doc) {
        return Benefit.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error getting benefits by type: $e');
    }
  }
}
