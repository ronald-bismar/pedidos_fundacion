import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/asistencia_beneficiario_repository_impl.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia_beneficiario.dart';
import 'package:pedidos_fundacion/domain/entities/programa.dart';

final attendanceGroupStreamProvider =
    StreamProvider.family<List<AttendanceBeneficiary>, String>((
      ref,
      idAttendance,
    ) {
      final attendanceRepository = ref.watch(attendanceRepoProvider);
      return attendanceRepository.listGroupByAttendance(idAttendance);
    });

final selectedGroupProvider = StateProvider<Group?>((ref) => null);
