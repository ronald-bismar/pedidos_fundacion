import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/di/services_provider.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia.dart';

final attendanceRemoteDataSourceProvider = Provider<AttendanceRemoteDataSource>(
  (ref) {
    final service = ref.watch(firestoreProvider);
    return AttendanceRemoteDataSource(service);
  },
);

class AttendanceRemoteDataSource {
  final FirebaseFirestore service;
  static const String _collection = 'attendance';

  AttendanceRemoteDataSource(this.service);

  Future<void> insert(Attendance attendance) async {
    try {
      await service
          .collection(_collection)
          .doc(attendance.id)
          .set(attendance.toMap());
    } catch (e) {
      throw Exception('Error creating attendance: $e');
    }
  }

  Future<void> delete(String attendanceId) async {
    try {
      await service.collection(_collection).doc(attendanceId).delete();
    } catch (e) {
      throw Exception('Error deleting attendance: $e');
    }
  }

  Future<void> update(Attendance attendance) async {
    try {
      await service
          .collection(_collection)
          .doc(attendance.id)
          .update(attendance.toMap());
    } catch (e) {
      throw Exception('Error updating attendance: $e');
    }
  }

  Future<Attendance?> getAttendance(String id) async {
    try {
      final doc = await service.collection(_collection).doc(id).get();

      if (doc.exists && doc.data() != null) {
        log('Documento existe intentando mappear...');
        return Attendance.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting attendance by ID: $e');
    }
  }

  Future<List<Attendance>> getAll() async {
    try {
      final querySnapshot = await service.collection(_collection).get();

      return querySnapshot.docs.map((doc) {
        return Attendance.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error getting attendance: $e');
    }
  }

  Future<Attendance?> getAttendanceByDate(String idGroup, DateTime date) async {
    try {
      String dateOnly =
          '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      log('dateOnly: $dateOnly');

      final querySnapshot = await service
          .collection(_collection)
          .where('idGroup', isEqualTo: idGroup)
          .where(
            'date',
            isEqualTo: dateOnly,
          ) // Sin índice necesario si hay pocos docs
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return Attendance.fromMap(querySnapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      throw Exception('Error getting attendance by date: $e');
    }
  }

  Future<List<Attendance>> getAttendanceOfMonth(
    String idMonthlyAttendance,
  ) async {
    try {
      final querySnapshot = await service
          .collection(_collection)
          .where('idMonthlyAttendance', isEqualTo: idMonthlyAttendance)
          .get();

      return querySnapshot.docs.map((doc) {
        return Attendance.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error getting attendance: $e');
    }
  }
}
