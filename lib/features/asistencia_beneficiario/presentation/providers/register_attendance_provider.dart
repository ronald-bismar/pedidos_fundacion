import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia_beneficiario.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/usecases/registrar_asistencia.dart';

final registerAttendanceProvider =
    Provider<
      void Function(Attendance, List<AttendanceBeneficiary>, BuildContext)
    >((ref) {
      final registerAttendanceUseCase = ref.watch(
        registerAttendanceUseCaseProvider,
      );

      return (
        Attendance attendance,
        List<AttendanceBeneficiary> attendanceBeneficiaries,
        BuildContext context,
      ) {
        registerAttendanceUseCase.call(
          attendance,
          attendanceBeneficiaries,
          context,
        );
      };
    });
