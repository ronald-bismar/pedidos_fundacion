import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/utils/uuid.dart';
import 'package:pedidos_fundacion/data/asistencia_beneficiario_repository_impl.dart';
import 'package:pedidos_fundacion/data/beneficiary_repository_impl.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia_beneficiario.dart';
import 'package:pedidos_fundacion/domain/entities/programa.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/model/estados_asistencia.dart';

final attendanceBeneficiariesStreamProvider =
    FutureProvider.family<List<AttendanceBeneficiary>, (String, DateTime)>((
      ref,
      params,
    ) async {
      final (idGroup, date) = params;
      final attendanceRepository = ref.watch(attendanceRepoProvider);
      final attendances = await attendanceRepository
          .listAttendanceBeneficiaries(idGroup, date);
      if (attendances.isEmpty) {
        final beneficiariesRepo = ref.watch(beneficiaryRepoProvider);
        final beneficiaries = await beneficiariesRepo
            .getBeneficiariesByGroupFuture(idGroup);

        final idAttendance = UUID.generateUUID();

        attendances.addAll(
          beneficiaries.map(
            (b) => AttendanceBeneficiary(
              id: UUID.generateUUID(),
              idBeneficiary: b.id,
              nameBeneficiary: '${b.name} ${b.lastName}',
              idAttendance: idAttendance,
              state: StateAttendance.notRegistered.name,
            ),
          ),
        );
      }

      return attendances;
    });

final selectedAttendanceGroupProvider = StateProvider<Group?>((ref) => null);
