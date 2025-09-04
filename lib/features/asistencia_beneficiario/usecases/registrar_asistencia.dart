import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/results/result_global.dart';
import 'package:pedidos_fundacion/core/utils/uuid.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/data/asistencia_beneficiario_repository_impl.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/domain/entities/asistencia.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/domain/entities/asistencia_beneficiario.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/domain/entities/asistencia_mensual.dart';
import 'package:pedidos_fundacion/domain/entities/programa.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/domain/repositories/asistencia_repository.dart';

final registerAttendanceUseCaseProvider = Provider(
  (ref) => RegisterAttendanceUseCase(ref.watch(attendanceRepoProvider)),
);

class RegisterAttendanceUseCase {
  final AttendanceRepository _attendanceRepository;

  RegisterAttendanceUseCase(this._attendanceRepository);

  Future<Result> call(
    Attendance attendance,
    List<AttendanceBeneficiary> attendanceBeneficiary,
    Group group,
  ) async {
    attendance = attendance.copyWith(idGroup: group.id);

    final hasMonthlyAttendance = attendance.idMonthlyAttendance.isNotEmpty;

    if (!hasMonthlyAttendance) {
      await searchAndAssignedMonthlyAttendance(group, attendance);
    }

    final isSuccess = await _attendanceRepository.saveAttendance(
      attendance,
      attendanceBeneficiary,
    );

    if (!isSuccess) {
      return Result.failure('No se pudo registrar la asistencia del grupo');
    }

    return Result.success('Asistencia registrada con éxito');
  }

  Future<void> searchAndAssignedMonthlyAttendance(
    Group group,
    Attendance attendance,
  ) async {
    final monthlyAttendance = await _attendanceRepository
        .getMonthlyAttendanceId(group.id, attendance.date.month);
    if (monthlyAttendance != null) {
      assignedMonthlyAttendance(attendance, monthlyAttendance);
    } else {
      await createMonthlyAttendance(group, attendance);
    }
  }

  void assignedMonthlyAttendance(
    Attendance attendance,
    String monthlyAttendance,
  ) {
    attendance.idMonthlyAttendance = monthlyAttendance;
  }

  Future<void> createMonthlyAttendance(
    Group group,
    Attendance attendance,
  ) async {
    final monthlyAttendance = MonthlyAttendance(
      id: UUID.generateUUID(),
      idGroup: group.id,
      nameGroup: group.groupName,
      month: attendance.date.month,
      year: attendance.date.year,
    );
    await _attendanceRepository.insertMonthlyAttendance(monthlyAttendance);
    attendance.idMonthlyAttendance = monthlyAttendance.id;
  }
}
