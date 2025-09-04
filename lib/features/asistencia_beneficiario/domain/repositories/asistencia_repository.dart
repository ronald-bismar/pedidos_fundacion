import 'package:pedidos_fundacion/features/asistencia_beneficiario/domain/entities/asistencia.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/domain/entities/asistencia_beneficiario.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/domain/entities/asistencia_mensual.dart';

abstract class AttendanceRepository {
  //MonthlyAttendanceBeneficiary
  Future<void> insertMonthlyAttendance(MonthlyAttendance attendance);
  Future<void> deleteMonthlyAttendance(MonthlyAttendance attendance);
  Future<void> updateMonthlyAttendance(MonthlyAttendance attendance);
  Stream<List<MonthlyAttendance>> getAllMonthlyAttendance();

  Future<void> insertAttendance(Attendance attendance);
  Future<void> deleteAttendance(Attendance attendance);
  Future<void> updateAttendance(Attendance attendance);
  Stream<List<Attendance>> getAllAttendance();

  //AttendanceBeneficiary

  Future<void> insertAttendanceBeneficiary(AttendanceBeneficiary c);
  Future<void> deleteAttendanceBeneficiary(AttendanceBeneficiary attendance);
  Future<void> updateAttendanceBeneficiary(AttendanceBeneficiary attendance);
  Future<AttendanceBeneficiary?> getAttendanceBeneficiary(String id);
  Future<List<AttendanceBeneficiary>> listGroupByAttendance(
    String idAttendance,
  );
  Future<void> insertAttendanceBeneficiaries(
    List<AttendanceBeneficiary> attendanceBeneficiaries,
  );
  Future<bool> saveAttendance(
    Attendance attendance,
    List<AttendanceBeneficiary> attendanceBeneficiaries,
  );
  Future<List<AttendanceBeneficiary>> listAttendanceBeneficiaries(
    String idGroup,
    DateTime date,
  );

  Future<MonthlyAttendance?> getMonthlyAttendanceByGroupAndMonth(
    String idGroup,
    int month,
  );
  Future<String?> getMonthlyAttendanceId(String idGroup, int month);
}
