import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/data/asistencia_beneficiario_repository_impl.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/domain/entities/asistencia_beneficiario.dart';
import 'package:pedidos_fundacion/domain/entities/programa.dart';

final attendanceGroupStreamProvider =
    FutureProvider.family<List<AttendanceBeneficiary>, String>((
      ref,
      idMonthlyAttendance,
    ) async {
      final attendanceRepository = ref.watch(attendanceRepoProvider);
      return await attendanceRepository.listGroupByAttendance(
        idMonthlyAttendance,
      );
    });

final selectedGroupProvider = StateProvider<Group?>((ref) => null);
