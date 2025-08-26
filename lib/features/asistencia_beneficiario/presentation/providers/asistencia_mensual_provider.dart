import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/asistencia_beneficiario_repository_impl.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia.dart';

final monthlyAttendanceProvider = StreamProvider.autoDispose<List<Attendance>>((
  ref,
) {
  final attendanceRepository = ref.watch(attendanceRepoProvider);
  return attendanceRepository.getAllAttendance();
});
