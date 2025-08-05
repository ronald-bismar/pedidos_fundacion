import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/mappers/encargado_mapper.dart';
import 'package:pedidos_fundacion/di/services_provider.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';

final coordinatorDataSourceProvider = Provider<CoordinatorRemoteDataSource>((
  ref,
) {
  final service = ref.watch(firestoreProvider);
  return CoordinatorRemoteDataSource(service);
});

class CoordinatorRemoteDataSource {
  final FirebaseFirestore service;
  static const String _collection = 'coordinators';

  CoordinatorRemoteDataSource(this.service);

  Future<void> insert(Coordinator coordinator) async {
    try {
      await service
          .collection(_collection)
          .doc(coordinator.id)
          .set(CoordinatorMapper.toJson(coordinator));
    } catch (e) {
      throw Exception('Error creating coordinator: $e');
    }
  }

  Future<Coordinator?> getCoordinator(String coordinatorId) async {
    try {
      final doc = await service
          .collection(_collection)
          .doc(coordinatorId)
          .get();

      if (doc.exists && doc.data() != null) {
        return CoordinatorMapper.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting coordinator by ID: $e');
    }
  }

  Future<List<Coordinator>> getAll() async {
    try {
      final querySnapshot = await service.collection(_collection).get();

      return querySnapshot.docs.map((doc) {
        return CoordinatorMapper.fromJson(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error getting all coordinators: $e');
    }
  }

  Future<void> update(Coordinator coordinator) async {
    try {
      await service
          .collection(_collection)
          .doc(coordinator.id)
          .update(CoordinatorMapper.toJson(coordinator));
    } catch (e) {
      throw Exception('Error updating coordinator: $e');
    }
  }

  Future<void> delete(String coordinatorId) async {
    try {
      await service.collection(_collection).doc(coordinatorId).delete();
    } catch (e) {
      throw Exception('Error deleting coordinator: $e');
    }
  }

  Future<bool> existsByDni(String dni) {
    try {
      final snapshot = service
          .collection('coordinators')
          .where('dni', isEqualTo: dni)
          .get();
      return snapshot.then((value) => value.docs.isNotEmpty);
    } catch (e) {
      log('Error checking DNI: $e');
      return Future.value(false);
    }
  }

  Future<bool> existsByEmail(String email) {
    try {
      final snapshot = service
          .collection('coordinators')
          .where('email', isEqualTo: email)
          .get();
      return snapshot.then((value) => value.docs.isNotEmpty);
    } catch (e) {
      log('Error checking email: $e');
      return Future.value(false);
    }
  }

  Future<void> updatePhotoId(Coordinator coordinator) async {
    try {
      await service
          .collection(_collection)
          .doc(coordinator.id)
          .update(CoordinatorMapper.toJsonPhoto(coordinator));
    } catch (e) {
      throw Exception('Error updating coordinator photo ID: $e');
    }
  }

  void updateLocation(Coordinator coordinator) {
    try {
      service
          .collection(_collection)
          .doc(coordinator.id)
          .update(CoordinatorMapper.toJsonLocation(coordinator));
    } catch (e) {
      throw Exception('Error updating coordinator photo ID: $e');
    }
  }

  Future<String?> getCoordinatorEmail(String username) async {
    try {
      final querySnapshot = await service
          .collection(_collection)
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return doc.data()['email'] as String?;
      }
      return null;
    } catch (e) {
      throw Exception('Error getting coordinator email: $e');
    }
  }

    void updateActive(Coordinator coordinator) {
    try {
      service
          .collection(_collection)
          .doc(coordinator.id)
          .update(CoordinatorMapper.toJsonActive(coordinator));
    } catch (e) {
      throw Exception('Error updating coordinator photo ID: $e');
    }
  }
}
