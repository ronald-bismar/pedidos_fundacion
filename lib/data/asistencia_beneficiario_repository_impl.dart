import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/datasources/asistencia/local_datasource.dart';
import 'package:pedidos_fundacion/data/datasources/asistencia/remote_datasource.dart';
import 'package:pedidos_fundacion/data/datasources/asistencia_beneficiario/local_datasource.dart';
import 'package:pedidos_fundacion/data/datasources/asistencia_beneficiario/remote_datasource.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia_beneficiario.dart';
import 'package:pedidos_fundacion/domain/repositories/asistencia_repository.dart';

final attendanceRepoProvider = Provider(
  (ref) => AttendanceRepositoryImpl(
    ref.watch(attendanceLocalDataSourceProvider),
    ref.watch(attendanceRemoteDataSourceProvider),
    ref.watch(attendanceBeneficiaryLocalDataSourceProvider),
    ref.watch(attendanceBeneficiaryRemoteDataSourceProvider),
  ),
);

class AttendanceRepositoryImpl extends AttendanceRepository {
  final AttendanceLocalDataSource localDataSource;
  final AttendanceRemoteDataSource remoteDataSource;
  final AttendanceBeneficiaryLocalDataSource
  attendanceBeneficiaryLocalDataSource;
  final AttendanceBeneficiaryRemoteDataSource
  attendanceBeneficiaryRemoteDataSource;

  AttendanceRepositoryImpl(
    this.localDataSource,
    this.remoteDataSource,
    this.attendanceBeneficiaryLocalDataSource,
    this.attendanceBeneficiaryRemoteDataSource,
  );

  @override
  Future<void> deleteAttendance(Attendance attendance) async {
    try {
      await localDataSource.delete(attendance);
      remoteDataSource.delete(attendance.id);
    } catch (e) {
      log('Error al eliminar la asistencia: $e');
    }
  }

  @override
  Future<void> deleteAttendanceBeneficiary(
    AttendanceBeneficiary attendance,
  ) async {
    try {
      await attendanceBeneficiaryLocalDataSource.delete(attendance);
      attendanceBeneficiaryRemoteDataSource.delete(attendance.id);
    } catch (e) {
      log('Error al eliminar la asistencia del beneficiario: $e');
    }
  }

  @override
  Future<List<Attendance>> getAllAttendance() async {
    try {
      final attendances = await localDataSource.getAll();
      if (attendances.isEmpty) {
        final attendancesRemote = await remoteDataSource.getAll();
        if (attendancesRemote.isNotEmpty) {
          await localDataSource.insertOrUpdate(attendancesRemote);
          return attendancesRemote;
        }
      }
      return [];
    } catch (e) {
      log('Error al obtener la asistencia: $e');
      return [];
    }
  }

  @override
  Future<AttendanceBeneficiary?> getAttendanceBeneficiary(String id) async {
    try {
      final attendancesBeneficiary = await attendanceBeneficiaryLocalDataSource
          .getAttendanceBeneficiary(id);
      if (attendancesBeneficiary == null) {
        final attendancesBeneficiaryRemote =
            await attendanceBeneficiaryRemoteDataSource
                .getAttendanceBeneficiary(id);
        if (attendancesBeneficiaryRemote != null) {
          await attendanceBeneficiaryLocalDataSource.insert(
            attendancesBeneficiaryRemote,
          );
          return attendancesBeneficiaryRemote;
        }
      }
      return null;
    } catch (e) {
      log('Error al obtener la asistencia: $e');
      return null;
    }
  }

  @override
  Future<void> insertAttendance(Attendance attendance) async {
    try {
      await localDataSource.insert(attendance);
      remoteDataSource.insert(attendance);
    } catch (e) {
      log('Error al insertar la asistencia: $e');
    }
  }

  @override
  Future<void> insertAttendanceBeneficiary(AttendanceBeneficiary c) async {
    try {
      await attendanceBeneficiaryLocalDataSource.insert(c);
      attendanceBeneficiaryRemoteDataSource.insert(c);
    } catch (e) {
      log('Error al insertar la asistencia del beneficiario: $e');
    }
  }

  @override
  Future<void> insertAttendanceBeneficiaries(
    List<AttendanceBeneficiary> attendanceBeneficiaries,
  ) async {
    try {
      await attendanceBeneficiaryLocalDataSource.insertOrUpdate(
        attendanceBeneficiaries,
      );
      attendanceBeneficiaryRemoteDataSource.insertOrUpdate(
        attendanceBeneficiaries,
      );
    } catch (e) {
      log('Error al insertar las asistencias de los beneficiarios: $e');
    }
  }

  @override
  Future<List<AttendanceBeneficiary>> listByAttendance(
    String idAttendance,
  ) async {
    try {
      final attendancesBeneficiary = await attendanceBeneficiaryLocalDataSource
          .listByAttendance(idAttendance);
      if (attendancesBeneficiary.isEmpty) {
        final attendancesBeneficiaryRemote =
            await attendanceBeneficiaryRemoteDataSource.listByAttendance(
              idAttendance,
            );
        if (attendancesBeneficiaryRemote.isNotEmpty) {
          await attendanceBeneficiaryLocalDataSource.insertOrUpdate(
            attendancesBeneficiaryRemote,
          );
          return attendancesBeneficiaryRemote;
        }
      }
      return [];
    } catch (e) {
      log('Error al obtener la asistencia del beneficiario: $e');
      return [];
    }
  }

  @override
  Future<void> updateAttendance(Attendance attendance) async {
    try {
      await localDataSource.update(attendance);
      remoteDataSource.update(attendance);
    } catch (e) {
      log('Error al actualizar la asistencia: $e');
    }
  }

  @override
  Future<void> updateAttendanceBeneficiary(
    AttendanceBeneficiary attendance,
  ) async {
    try {
      await attendanceBeneficiaryLocalDataSource.update(attendance);
      attendanceBeneficiaryRemoteDataSource.update(attendance);
    } catch (e) {
      log('Error al actualizar la asistencia del beneficiario: $e');
    }
  }

  @override
  Future<bool> saveAttendance(
    Attendance attendance,
    List<AttendanceBeneficiary> attendanceBeneficiaries,
  ) async {
    try {
      log('Guardando la asistencia');
      await insertAttendance(attendance);
      await insertAttendanceBeneficiaries(attendanceBeneficiaries);
      return true;
    } catch (e) {
      log('Error al guardar la asistencia: $e');
      return false;
    }
  }
}
