import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/mappers/beneficiario_mapper.dart';
import 'package:pedidos_fundacion/di/services_provider.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';

final beneficiaryRemoteDataSourceProvider =
    Provider<BeneficiaryRemoteDataSource>((ref) {
      final service = ref.watch(firestoreProvider);
      return BeneficiaryRemoteDataSource(service);
    });

class BeneficiaryRemoteDataSource {
  final FirebaseFirestore service;
  static const String _collection = 'beneficiaries';
  static const String _collectionLastCorrelative = 'lastCorrelative';
  static const idLastCorrelative = '60b954de-4c6a-4616-bdbb-b601ebdb3c71';

  //Reemplazar por el ultimo correlativo de la empresa
  static const firstCorrelative = 000000000;

  BeneficiaryRemoteDataSource(this.service);

  Future<void> insert(Beneficiary beneficiary) async {
    try {
      await service
          .collection(_collection)
          .doc(beneficiary.id)
          .set(BeneficiaryMapper.toMap(beneficiary));
    } catch (e) {
      throw Exception('Error creating coordinator: $e');
    }
  }

  Future<Beneficiary?> getBeneficiary(String beneficiaryId) async {
    try {
      final doc = await service
          .collection(_collection)
          .doc(beneficiaryId)
          .get();

      if (doc.exists && doc.data() != null) {
        log('Documento existe intentando mappear...');
        return BeneficiaryMapper.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting beneficiary by ID: $e');
    }
  }

  Future<List<Beneficiary>> getAll() async {
    try {
      final querySnapshot = await service.collection(_collection).get();

      return querySnapshot.docs.map((doc) {
        return BeneficiaryMapper.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error getting all beneficiaries: $e');
    }
  }

  Future<void> update(Beneficiary beneficiary) async {
    try {
      await service
          .collection(_collection)
          .doc(beneficiary.id)
          .update(BeneficiaryMapper.toMap(beneficiary));
    } catch (e) {
      throw Exception('Error updating beneficiary: $e');
    }
  }

  Future<void> delete(String beneficiaryId) async {
    try {
      await service.collection(_collection).doc(beneficiaryId).delete();
    } catch (e) {
      throw Exception('Error deleting beneficiary: $e');
    }
  }

  Future<bool> existsByDni(String dni) {
    try {
      final snapshot = service
          .collection(_collection)
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
          .collection(_collection)
          .where('email', isEqualTo: email)
          .get();
      return snapshot.then((value) => value.docs.isNotEmpty);
    } catch (e) {
      log('Error checking email: $e');
      return Future.value(false);
    }
  }

  Future<void> updatePhotoId(Beneficiary beneficiary) async {
    try {
      await service
          .collection(_collection)
          .doc(beneficiary.id)
          .update(BeneficiaryMapper.toJsonPhoto(beneficiary));
    } catch (e) {
      throw Exception('Error updating beneficiary photo ID: $e');
    }
  }

  void updateLocationAndPhone(Beneficiary beneficiary) {
    try {
      service
          .collection(_collection)
          .doc(beneficiary.id)
          .update(BeneficiaryMapper.toJsonLocationAndPhone(beneficiary));
    } catch (e) {
      throw Exception('Error updating beneficiary photo ID: $e');
    }
  }

  Future<String?> getBeneficiaryEmail(String username) async {
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
      throw Exception('Error getting beneficiary email: $e');
    }
  }

  void updateActive(Beneficiary beneficiary) {
    try {
      service
          .collection(_collection)
          .doc(beneficiary.id)
          .update(BeneficiaryMapper.toJsonActive(beneficiary));
    } catch (e) {
      throw Exception('Error updating beneficiary photo ID: $e');
    }
  }

  void updateGroup(Beneficiary beneficiary, String idGroup) {
    try {
      beneficiary = beneficiary.copyWith(idGroup: idGroup);
      service
          .collection(_collection)
          .doc(beneficiary.id)
          .update(BeneficiaryMapper.toJsonGroup(beneficiary));
    } catch (e) {
      throw Exception('Error updating beneficiary photo ID: $e');
    }
  }

  Future<List<Beneficiary>> getByGroup(String idGroup) async {
    try {
      log('Consultando beneficiarios al servidor remoto');
      final querySnapshot = await service
          .collection(_collection)
          .where('idGroup', isEqualTo: idGroup)
          .get();

      log('Retornando: ${querySnapshot.docs.length} beneficiarios');

      return querySnapshot.docs
          .where((doc) => doc.exists)
          .map((doc) => BeneficiaryMapper.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error getting beneficiaries by group: $e');
    }
  }

  Future<int?> getLastCorrelative() async {
    try {
      final querySnapshot = await service
          .collection(_collectionLastCorrelative)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return doc.data()['number'] as int?;
      } else {
        return firstCorrelative;
      }
    } catch (e) {
      log('Error getting last correlative: $e');
      return null;
    }
  }

  Future<void> saveLastCorrelative(int codeCorrelative) async {
    try {
      await service
          .collection(_collectionLastCorrelative)
          .doc(idLastCorrelative)
          .set({'prefix': 'BO', 'number': codeCorrelative});
    } catch (e) {
      log('Error saving correlative: $e');
    }
  }

   //  NUEVO MÉTODO
  Stream<List<Beneficiary>> streamByGroup(String idGroup) {
    try {
      return service
          .collection(_collection)
          .where('idGroup', isEqualTo: idGroup)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs
              .where((doc) => doc.exists)
              .map((doc) => BeneficiaryMapper.fromJson(doc.data()))
              .toList());
    } catch (e) {
      throw Exception('Error getting beneficiaries by group: $e');
    }
  }
}
