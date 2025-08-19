import 'package:pedidos_fundacion/domain/entities/asistencia.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia_beneficiario.dart';

abstract class AttendanceRepository {
  Future<void> insertAttendance(Attendance attendance);
  Future<void> deleteAttendance(Attendance attendance);
  Future<void> updateAttendance(Attendance attendance);
  Future<List<Attendance>> getAllAttendance();

  //AttendanceBeneficiary

  Future<void> insertAttendanceBeneficiary(AttendanceBeneficiary c);
  Future<void> deleteAttendanceBeneficiary(AttendanceBeneficiary attendance);
  Future<void> updateAttendanceBeneficiary(AttendanceBeneficiary attendance);
  Future<AttendanceBeneficiary?> getAttendanceBeneficiary(String id);
  Future<List<AttendanceBeneficiary>> listByAttendance(String idAttendance);
  Future<void> insertAttendanceBeneficiaries(
    List<AttendanceBeneficiary> attendanceBeneficiaries,
  );
  Future<bool> saveAttendance(
    Attendance attendance,
    List<AttendanceBeneficiary> attendanceBeneficiaries,
  );
}
