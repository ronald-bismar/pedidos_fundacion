import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/di/services_provider.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/entrega.dart';

final deliveryRemoteDataSourceProvider = Provider<DeliveryRemoteDataSource>((
  ref,
) {
  final service = ref.watch(firestoreProvider);
  return DeliveryRemoteDataSource(service);
});

class DeliveryRemoteDataSource {
  final FirebaseFirestore service;
  static const String _collection = 'delivery';

  DeliveryRemoteDataSource(this.service);

  Future<void> insert(Delivery delivery) async {
    try {
      await service
          .collection(_collection)
          .doc(delivery.id)
          .set(delivery.toMap());
    } catch (e) {
      throw Exception('Error creating delivery: $e');
    }
  }

  Future<void> delete(String deliveryId) async {
    try {
      await service.collection(_collection).doc(deliveryId).delete();
    } catch (e) {
      throw Exception('Error deleting delivery: $e');
    }
  }

  Future<void> update(Delivery delivery) async {
    try {
      await service
          .collection(_collection)
          .doc(delivery.id)
          .update(delivery.toMap());
    } catch (e) {
      throw Exception('Error updating delivery: $e');
    }
  }

  Future<Delivery?> getDelivery(String id) async {
    try {
      final doc = await service.collection(_collection).doc(id).get();

      if (doc.exists && doc.data() != null) {
        log('Documento existe intentando mappear...');
        return Delivery.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting delivery by ID: $e');
    }
  }

  Future<List<Delivery>> getAll() async {
    try {
      final querySnapshot = await service.collection(_collection).get();

      return querySnapshot.docs.map((doc) {
        return Delivery.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error getting deliveries: $e');
    }
  }

  Future<List<Delivery>> getByGroup(String idGroup) async {
    try {
      final querySnapshot = await service
          .collection(_collection)
          .where('idGroup', isEqualTo: idGroup)
          .get();

      return querySnapshot.docs.map((doc) {
        return Delivery.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error getting deliveries by group: $e');
    }
  }

  Future<List<Delivery>> getByCoordinator(String idCoordinator) async {
    try {
      final querySnapshot = await service
          .collection(_collection)
          .where('idCoordinator', isEqualTo: idCoordinator)
          .get();

      return querySnapshot.docs.map((doc) {
        return Delivery.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error getting deliveries by coordinator: $e');
    }
  }

  Future<List<Delivery>> getByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      String startDateStr = startDate.toIso8601String().substring(0, 10);
      String endDateStr = endDate.toIso8601String().substring(0, 10);

      final querySnapshot = await service
          .collection(_collection)
          .where('deliveryDate', isGreaterThanOrEqualTo: startDateStr)
          .where('deliveryDate', isLessThanOrEqualTo: endDateStr)
          .get();

      return querySnapshot.docs.map((doc) {
        return Delivery.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error getting deliveries by date range: $e');
    }
  }
}
