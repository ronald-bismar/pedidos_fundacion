import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/widgets/snackbar.dart';
import 'package:pedidos_fundacion/data/asistencia_beneficiario_repository_impl.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia_beneficiario.dart';
import 'package:pedidos_fundacion/domain/repositories/asistencia_repository.dart';

final registerAttendanceUseCaseProvider = Provider(
  (ref) => RegisterAttendanceUseCase(ref.watch(attendanceRepoProvider)),
);

//Offline first: Consultamos siempre a la base de datos local y despues a la base de datos remota
class RegisterAttendanceUseCase {
  final AttendanceRepository _attendanceRepository;

  RegisterAttendanceUseCase(this._attendanceRepository);

  Future<void> call(
    Attendance attendance,
    List<AttendanceBeneficiary> attendanceBeneficiary,
    BuildContext context,
  ) async {
    final isSuccess = await _attendanceRepository.saveAttendance(
      attendance,
      attendanceBeneficiary,
    );

    if (!isSuccess) {
      MySnackBar.error(context, 'No se pudo registrar la asistencia del grupo');
      return;
    }
  }
}
