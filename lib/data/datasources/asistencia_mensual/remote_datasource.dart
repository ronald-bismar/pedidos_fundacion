import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/di/services_provider.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia_mensual.dart';

final monthlyAttendanceRemoteDataSourceProvider =
    Provider<MonthlyAttendanceRemoteDataSource>((ref) {
      final service = ref.watch(firestoreProvider);
      return MonthlyAttendanceRemoteDataSource(service);
    });

class MonthlyAttendanceRemoteDataSource {
  final FirebaseFirestore service;
  static const String _collection = 'monthlyAttendance';

  MonthlyAttendanceRemoteDataSource(this.service);

  Future<void> insert(MonthlyAttendance attendance) async {
    try {
      await service
          .collection(_collection)
          .doc(attendance.id)
          .set(attendance.toMap());
    } catch (e) {
      throw Exception('Error creating monthly attendance: $e');
    }
  }

  Future<void> delete(String attendanceId) async {
    try {
      await service.collection(_collection).doc(attendanceId).delete();
    } catch (e) {
      throw Exception('Error deleting monthly attendance: $e');
    }
  }

  Future<void> update(MonthlyAttendance attendance) async {
    try {
      await service
          .collection(_collection)
          .doc(attendance.id)
          .update(attendance.toMap());
    } catch (e) {
      throw Exception('Error updating monthly attendance: $e');
    }
  }

  Future<MonthlyAttendance?> getAttendance(String id) async {
    try {
      final doc = await service.collection(_collection).doc(id).get();

      if (doc.exists && doc.data() != null) {
        log('Documento existe intentando mappear...');
        return MonthlyAttendance.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting monthly attendance by ID: $e');
    }
  }

  Future<List<MonthlyAttendance>> getAll() async {
    try {
      final querySnapshot = await service.collection(_collection).get();

      return querySnapshot.docs.map((doc) {
        return MonthlyAttendance.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error getting monthly attendance: $e');
    }
  }

  Future<MonthlyAttendance?> getAttendanceByDate(
    String idGroup,
    DateTime date,
  ) async {
    try {
      String dateOnly =
          '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final querySnapshot = await service
          .collection(_collection)
          .where('idGroup', isEqualTo: idGroup)
          .where(
            'dateOnly',
            isEqualTo: dateOnly,
          ) // Sin índice necesario si hay pocos docs
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return MonthlyAttendance.fromMap(querySnapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      throw Exception('Error getting monthly attendance by date: $e');
    }
  }

  Future<Future<MonthlyAttendance?>> getMonthlyAttendanceByGroupAndMonth(
    String idGroup,
    int month,
  ) async {}

  Future<String?> getMonthlyAttendanceId(String idGroup, int month) async {
    try {
      final querySnapshot = await service
          .collection(_collection)
          .where('idGroup', isEqualTo: idGroup)
          .where('month', isEqualTo: month)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      }
      return null;
    } catch (e) {
      log('Error getting monthly attendance by group and month: $e');
      return null;
    }
  }
}
