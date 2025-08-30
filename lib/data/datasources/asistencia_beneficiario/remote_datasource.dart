import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/di/services_provider.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia_beneficiario.dart';

final attendanceBeneficiaryRemoteDataSourceProvider =
    Provider<AttendanceBeneficiaryRemoteDataSource>((ref) {
      final service = ref.watch(firestoreProvider);
      return AttendanceBeneficiaryRemoteDataSource(service);
    });

class AttendanceBeneficiaryRemoteDataSource {
  final FirebaseFirestore service;
  static const String _collection = 'attendanceBeneficiaries';

  AttendanceBeneficiaryRemoteDataSource(this.service);

  Future<void> insert(AttendanceBeneficiary attendanceBeneficiary) async {
    try {
      await service
          .collection(_collection)
          .doc(attendanceBeneficiary.id)
          .set(attendanceBeneficiary.toMap());
    } catch (e) {
      throw Exception('Error creating attendance beneficiary: $e');
    }
  }

  Future<void> delete(String attendanceBeneficiaryId) async {
    try {
      await service
          .collection(_collection)
          .doc(attendanceBeneficiaryId)
          .delete();
    } catch (e) {
      throw Exception('Error deleting attendance beneficiary: $e');
    }
  }

  Future<void> update(AttendanceBeneficiary attendanceBeneficiary) async {
    try {
      await service
          .collection(_collection)
          .doc(attendanceBeneficiary.id)
          .update(attendanceBeneficiary.toMap());
    } catch (e) {
      throw Exception('Error updating attendance beneficiary: $e');
    }
  }

  Future<AttendanceBeneficiary?> getAttendanceBeneficiary(
    String attendanceBeneficiaryId,
  ) async {
    try {
      final doc = await service
          .collection(_collection)
          .doc(attendanceBeneficiaryId)
          .get();

      if (doc.exists && doc.data() != null) {
        log('Documento existe intentando mappear...');
        return AttendanceBeneficiary.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting beneficiary by ID: $e');
    }
  }

  Future<List<AttendanceBeneficiary>> listByAttendance(
    String idAttendance,
  ) async {
    try {
      final querySnapshot = await service
          .collection(_collection)
          .where('idAttendance', isEqualTo: idAttendance)
          .get();

      return querySnapshot.docs.map((doc) {
        return AttendanceBeneficiary.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error getting attendance beneficiaries: $e');
    }
  }

  Future<List<AttendanceBeneficiary>> listByAttendances(
    List<String> idAttendances,
  ) async {
    try {
      // Validación: Si no hay IDs, retorna lista vacía
      if (idAttendances.isEmpty) {
        return [];
      }

      // Firestore tiene límite de 10 elementos en whereIn
      // Si hay más de 10, necesitamos hacer múltiples consultas
      if (idAttendances.length <= 10) {
        final querySnapshot = await service
            .collection(_collection)
            .where('idAttendance', whereIn: idAttendances)
            .get();

        return querySnapshot.docs.map((doc) {
          return AttendanceBeneficiary.fromMap(doc.data());
        }).toList();
      } else {
        // Para más de 10 elementos, dividir en chunks
        List<AttendanceBeneficiary> allResults = [];

        for (int i = 0; i < idAttendances.length; i += 10) {
          final chunk = idAttendances.sublist(
            i,
            (i + 10 > idAttendances.length) ? idAttendances.length : i + 10,
          );

          final querySnapshot = await service
              .collection(_collection)
              .where('idAttendance', whereIn: chunk)
              .get();

          final chunkResults = querySnapshot.docs.map((doc) {
            return AttendanceBeneficiary.fromMap(doc.data());
          }).toList();

          allResults.addAll(chunkResults);
        }

        return allResults;
      }
    } catch (e) {
      throw Exception('Error getting attendance beneficiaries: $e');
    }
  }

  Future<void> insertOrUpdate(List<AttendanceBeneficiary> beneficiaries) async {
    try {
      final batch = service.batch();

      for (final beneficiary in beneficiaries) {
        final docRef = service.collection(_collection).doc(beneficiary.id);
        batch.set(docRef, beneficiary.toMap());
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Error inserting multiple attendance beneficiaries: $e');
    }
  }
}
