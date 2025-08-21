import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/widgets/snackbar.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia_beneficiario.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/usecases/registrar_asistencia.dart';

final registerAttendanceProvider =
    Provider<
      Future<void> Function(
        Attendance,
        List<AttendanceBeneficiary>,
        BuildContext,
      )
    >((ref) {
      final registerAttendanceUseCase = ref.watch(
        registerAttendanceUseCaseProvider,
      );

      return (
        Attendance attendance,
        List<AttendanceBeneficiary> attendanceBeneficiaries,
        BuildContext context,
      ) async {
        MySnackBar.show(
          context,
          'Guardando asistencia...',
          backgroundColor: secondary,
          durationInSeconds: 1,
        );

        final result = await registerAttendanceUseCase.call(
          attendance,
          attendanceBeneficiaries,
        );

        if (context.mounted) {
          if (result.isSuccess) {
            MySnackBar.success(context, result.data);
          } else {
            MySnackBar.error(
              context,
              result.error ?? 'No se pudo guardar la asistencia',
            );
          }
        }
      };
    });
