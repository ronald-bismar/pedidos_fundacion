import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/datasources/asistencia/local_datasource.dart';
import 'package:pedidos_fundacion/data/datasources/asistencia/remote_datasource.dart';
import 'package:pedidos_fundacion/data/datasources/asistencia_beneficiario/local_datasource.dart';
import 'package:pedidos_fundacion/data/datasources/asistencia_beneficiario/remote_datasource.dart';
import 'package:pedidos_fundacion/data/datasources/asistencia_mensual/local_datasource.dart';
import 'package:pedidos_fundacion/data/datasources/asistencia_mensual/remote_datasource.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia_beneficiario.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia_mensual.dart';
import 'package:pedidos_fundacion/domain/repositories/asistencia_repository.dart';

final attendanceRepoProvider = Provider(
  (ref) => AttendanceRepositoryImpl(
    ref.watch(attendanceLocalDataSourceProvider),
    ref.watch(attendanceRemoteDataSourceProvider),
    ref.watch(attendanceBeneficiaryLocalDataSourceProvider),
    ref.watch(attendanceBeneficiaryRemoteDataSourceProvider),
    ref.watch(monthlyAttendanceLocalDataSourceProvider),
    ref.watch(monthlyAttendanceRemoteDataSourceProvider),
  ),
);

class AttendanceRepositoryImpl extends AttendanceRepository {
  final AttendanceLocalDataSource attendanceLocalDataSource;
  final AttendanceRemoteDataSource attendanceRemoteDataSource;
  final AttendanceBeneficiaryLocalDataSource
  attendanceBeneficiaryLocalDataSource;
  final AttendanceBeneficiaryRemoteDataSource
  attendanceBeneficiaryRemoteDataSource;
  final MonthlyAttendanceLocalDataSource monthlyAttendanceLocalDataSource;
  final MonthlyAttendanceRemoteDataSource monthlyAttendanceRemoteDataSource;

  AttendanceRepositoryImpl(
    this.attendanceLocalDataSource,
    this.attendanceRemoteDataSource,
    this.attendanceBeneficiaryLocalDataSource,
    this.attendanceBeneficiaryRemoteDataSource,
    this.monthlyAttendanceLocalDataSource,
    this.monthlyAttendanceRemoteDataSource,
  );

  // ============================================================================
  // ATTENDANCE METHODS
  // ============================================================================

  @override
  Stream<List<Attendance>> getAllAttendance() async* {
    try {
      final attendances = await attendanceLocalDataSource.getAll();
      if (attendances.isNotEmpty) {
        yield attendances;
      }

      final attendancesRemote = await attendanceRemoteDataSource.getAll();
      if (attendancesRemote.isNotEmpty) {
        await attendanceLocalDataSource.insertOrUpdate(attendancesRemote);
        yield attendancesRemote;
      }
      yield attendances;
    } catch (e) {
      log('Error al obtener la asistencia: $e');
      yield [];
    }
  }

  @override
  Future<void> insertAttendance(Attendance attendance) async {
    try {
      await attendanceLocalDataSource.insert(attendance);
      attendanceRemoteDataSource.insert(attendance);
    } catch (e) {
      log('Error al insertar la asistencia: $e');
    }
  }

  @override
  Future<void> updateAttendance(Attendance attendance) async {
    try {
      await attendanceLocalDataSource.update(attendance);
      attendanceRemoteDataSource.update(attendance);
    } catch (e) {
      log('Error al actualizar la asistencia: $e');
    }
  }

  @override
  Future<void> deleteAttendance(Attendance attendance) async {
    try {
      await attendanceLocalDataSource.delete(attendance);
      attendanceRemoteDataSource.delete(attendance.id);
    } catch (e) {
      log('Error al eliminar la asistencia: $e');
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

  // ============================================================================
  // ATTENDANCE BENEFICIARY METHODS
  // ============================================================================

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
  Future<List<AttendanceBeneficiary>> listGroupByAttendance(
    String idMonthlyAttendance,
  ) async {
    try {
      List<Attendance> attendancesOfMonth = [];
      attendancesOfMonth = await attendanceLocalDataSource.getAttendanceOfMonth(
        idMonthlyAttendance,
      );

      if (attendancesOfMonth.isEmpty) {
        attendancesOfMonth = await attendanceRemoteDataSource
            .getAttendanceOfMonth(idMonthlyAttendance);

        if (attendancesOfMonth.isNotEmpty) {
          await attendanceLocalDataSource.insertOrUpdate(attendancesOfMonth);
        }
      }

      if (attendancesOfMonth.isEmpty) return [];

      final idsAttendances = attendancesOfMonth.map((e) => e.id).toList();

      final attendancesBeneficiary = await attendanceBeneficiaryLocalDataSource
          .listByAttendances(idsAttendances);

      if (attendancesBeneficiary.isNotEmpty) return attendancesBeneficiary;

      final attendancesBeneficiaryRemote =
          await attendanceBeneficiaryRemoteDataSource.listByAttendances(
            idsAttendances,
          );

      if (attendancesBeneficiaryRemote.isNotEmpty) {
        await attendanceBeneficiaryLocalDataSource.insertOrUpdate(
          attendancesBeneficiaryRemote,
        );
        return attendancesBeneficiaryRemote;
      }
      return [];
    } catch (e) {
      log('Error al obtener la asistencia del beneficiario: $e');
      return [];
    }
  }

  @override
  Future<List<AttendanceBeneficiary>> listAttendanceBeneficiaries(
    String idGroup,
    DateTime date,
  ) async {
    try {
      final attendance =
          await attendanceLocalDataSource.getAttendanceByDate(idGroup, date) ??
          await attendanceRemoteDataSource.getAttendanceByDate(idGroup, date);

      if (attendance == null) return [];

      final localBeneficiaries = await attendanceBeneficiaryLocalDataSource
          .listByAttendance(attendance.id);

      if (localBeneficiaries.isNotEmpty) return localBeneficiaries;

      return await attendanceBeneficiaryRemoteDataSource.listByAttendance(
        attendance.id,
      );
    } catch (e) {
      log('Error al obtener la asistencia del beneficiario: $e');
      return [];
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

  // ============================================================================
  // MONTHLY ATTENDANCE METHODS
  // ============================================================================

  @override
  Stream<List<MonthlyAttendance>> getAllMonthlyAttendance() async* {
    try {
      final monthlyAttendance = await monthlyAttendanceLocalDataSource.getAll();
      yield monthlyAttendance;
      final monthlyAttendanceRemote = await monthlyAttendanceRemoteDataSource
          .getAll();
      if (monthlyAttendanceRemote.isNotEmpty) {
        await monthlyAttendanceLocalDataSource.insertOrUpdate(
          monthlyAttendanceRemote,
        );
        yield monthlyAttendanceRemote;
      }
    } catch (e) {
      log('Error al obtener la asistencia mensual: $e');
      yield [];
    }
  }

  @override
  Future<void> insertMonthlyAttendance(MonthlyAttendance attendance) async {
    try {
      await monthlyAttendanceLocalDataSource.insert(attendance);
      monthlyAttendanceRemoteDataSource.insert(attendance);
    } catch (e) {
      log('Error al insertar la asistencia mensual: $e');
    }
  }

  @override
  Future<void> updateMonthlyAttendance(MonthlyAttendance attendance) async {
    try {
      await monthlyAttendanceLocalDataSource.update(attendance);
      monthlyAttendanceRemoteDataSource.update(attendance);
    } catch (e) {
      log('Error al actualizar la asistencia mensual: $e');
    }
  }

  @override
  Future<void> deleteMonthlyAttendance(MonthlyAttendance attendance) async {
    try {
      await monthlyAttendanceLocalDataSource.delete(attendance);
      monthlyAttendanceRemoteDataSource.delete(attendance.id);
    } catch (e) {
      log('Error al eliminar la asistencia mensual: $e');
    }
  }

  @override
  Future<MonthlyAttendance?> getMonthlyAttendanceByGroupAndMonth(
    String idGroup,
    int month,
  ) async {
    try {
      final monthlyAttendance = await monthlyAttendanceLocalDataSource
          .getMonthlyAttendanceByGroupAndMonth(idGroup, month);
      if (monthlyAttendance != null) {
        return monthlyAttendance;
      }
      return await monthlyAttendanceRemoteDataSource
          .getMonthlyAttendanceByGroupAndMonth(idGroup, month);
    } catch (e) {
      log('Error al obtener la asistencia mensual: $e');
      return null;
    }
  }

  @override
  Future<String?> getMonthlyAttendanceId(String idGroup, int month) async {
    try {
      final monthlyAttendance = await monthlyAttendanceLocalDataSource
          .getMonthlyAttendanceId(idGroup, month);
      if (monthlyAttendance != null) {
        return monthlyAttendance;
      }
      return await monthlyAttendanceRemoteDataSource.getMonthlyAttendanceId(
        idGroup,
        month,
      );
    } catch (e) {
      log('Error al obtener la asistencia mensual: $e');
      return null;
    }
  }
}
