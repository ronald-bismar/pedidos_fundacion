import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/di/services_provider.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/entrega_beneficiario.dart';

final deliveryBeneficiaryRemoteDataSourceProvider =
    Provider<DeliveryBeneficiaryRemoteDataSource>((ref) {
      final service = ref.watch(firestoreProvider);
      return DeliveryBeneficiaryRemoteDataSource(service);
    });

class DeliveryBeneficiaryRemoteDataSource {
  final FirebaseFirestore service;
  static const String _collection = 'deliveryBeneficiary';

  DeliveryBeneficiaryRemoteDataSource(this.service);

  Future<void> insert(DeliveryBeneficiary deliveryBeneficiary) async {
    try {
      await service
          .collection(_collection)
          .doc(deliveryBeneficiary.id)
          .set(deliveryBeneficiary.toMap());
    } catch (e) {
      throw Exception('Error creating delivery beneficiary: $e');
    }
  }

  Future<void> delete(String deliveryBeneficiaryId) async {
    try {
      await service.collection(_collection).doc(deliveryBeneficiaryId).delete();
    } catch (e) {
      throw Exception('Error deleting delivery beneficiary: $e');
    }
  }

  Future<void> update(DeliveryBeneficiary deliveryBeneficiary) async {
    try {
      await service
          .collection(_collection)
          .doc(deliveryBeneficiary.id)
          .update(deliveryBeneficiary.toMap());
    } catch (e) {
      throw Exception('Error updating delivery beneficiary: $e');
    }
  }

  Future<DeliveryBeneficiary?> getDeliveryBeneficiary(String id) async {
    try {
      final doc = await service.collection(_collection).doc(id).get();

      if (doc.exists && doc.data() != null) {
        log('Documento existe intentando mappear...');
        return DeliveryBeneficiary.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting delivery beneficiary by ID: $e');
    }
  }

  Future<List<DeliveryBeneficiary>> getAll() async {
    try {
      final querySnapshot = await service.collection(_collection).get();

      return querySnapshot.docs.map((doc) {
        return DeliveryBeneficiary.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error getting delivery beneficiaries: $e');
    }
  }

  Future<List<DeliveryBeneficiary>> getByDelivery(String idDelivery) async {
    try {
      final querySnapshot = await service
          .collection(_collection)
          .where('idDelivery', isEqualTo: idDelivery)
          .get();

      return querySnapshot.docs.map((doc) {
        return DeliveryBeneficiary.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error getting delivery beneficiaries by delivery: $e');
    }
  }

  Future<List<DeliveryBeneficiary>> getBeneficiaryByCode(
    String codeBeneficiary,
  ) async {
    try {
      final querySnapshot = await service
          .collection(_collection)
          .where('codeBeneficiary', isEqualTo: codeBeneficiary)
          .get();

      return querySnapshot.docs.map((doc) {
        return DeliveryBeneficiary.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error getting delivery beneficiaries by code: $e');
    }
  }

  Future<List<DeliveryBeneficiary>> getByState(String state) async {
    try {
      final querySnapshot = await service
          .collection(_collection)
          .where('state', isEqualTo: state)
          .get();

      return querySnapshot.docs.map((doc) {
        return DeliveryBeneficiary.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error getting delivery beneficiaries by state: $e');
    }
  }

  void insertList(List<DeliveryBeneficiary> deliveryBeneficiaries) async {
    try {
      // Validar que no exceda el límite de Firestore (500 operaciones por batch)
      if (deliveryBeneficiaries.length > 500) {
        throw Exception(
          'La lista excede el límite máximo de 500 deliveries por batch',
        );
      }

      // Crear un batch para operaciones atómicas
      WriteBatch batch = service.batch();

      // Agregar cada delivery al batch
      for (DeliveryBeneficiary delivery in deliveryBeneficiaries) {
        DocumentReference docRef = service
            .collection(_collection)
            .doc(delivery.id);

        batch.set(docRef, delivery.toMap());
      }

      // Ejecutar todas las operaciones en una sola transacción
      await batch.commit();

      log('${deliveryBeneficiaries.length} deliveries guardados exitosamente');
    } catch (e) {
      throw Exception('Error guardando lista de deliveries: $e');
    }
  }
}
