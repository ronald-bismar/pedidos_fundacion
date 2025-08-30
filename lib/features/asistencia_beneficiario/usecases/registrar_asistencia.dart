import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/results/result_global.dart';
import 'package:pedidos_fundacion/data/asistencia_beneficiario_repository_impl.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia_beneficiario.dart';
import 'package:pedidos_fundacion/domain/repositories/asistencia_repository.dart';

final registerAttendanceUseCaseProvider = Provider(
  (ref) => RegisterAttendanceUseCase(ref.watch(attendanceRepoProvider)),
);

class RegisterAttendanceUseCase {
  final AttendanceRepository _attendanceRepository;

  RegisterAttendanceUseCase(this._attendanceRepository);

  Future<Result> call(
    Attendance attendance,
    List<AttendanceBeneficiary> attendanceBeneficiary,
    String idGroup,
  ) async {
    final hasMonthlyAttendance = attendance.idMonthlyAttendance.isNotEmpty;

    //Si no tiene asistencia de mes buscamos una del grupo y del mes...
    if (!hasMonthlyAttendance) {
      final monthlyAttendance = await _attendanceRepository
          .getMonthlyAttendanceByGroupAndMonth(idGroup, attendance.date.month);
    }

    //Si no hay una asistencia del mes para este grupo, la creamos
    final isSuccess = await _attendanceRepository.saveAttendance(
      attendance,
      attendanceBeneficiary,
    );

    if (!isSuccess) {
      return Result.failure('No se pudo registrar la asistencia del grupo');
    }

    return Result.success('Asistencia registrada con éxito');
  }
}
