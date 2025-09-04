import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/domain/entities/asistencia_beneficiario.dart';

class CardHistoryAttendanceBeneficiary extends ConsumerStatefulWidget {
  final String nameBeneficiary;
  final List<AttendanceBeneficiary> attendances;

  const CardHistoryAttendanceBeneficiary(
    this.nameBeneficiary,
    this.attendances, {
    super.key,
  });

  @override
  ConsumerState<CardHistoryAttendanceBeneficiary> createState() =>
      _CardHistoryAttendanceBeneficiaryState();
}

class _CardHistoryAttendanceBeneficiaryState
    extends ConsumerState<CardHistoryAttendanceBeneficiary> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 4,
              top: 10,
              right: 8,
              left: 8,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                subTitle(
                  widget.nameBeneficiary,
                  fontWeight: FontWeight.w500,
                  textColor: dark,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10),

                // Grid de asistencias dividido en filas de 4
                _buildAttendanceGrid(),
              ],
            ),
          ),
        ),
        Divider(color: Colors.grey.shade300, thickness: 1, height: 1),
      ],
    );
  }

  Widget _buildAttendanceGrid() {
    // Dividir en grupos de 4
    List<List<AttendanceBeneficiary>> rows = [];
    for (int i = 0; i < widget.attendances.length; i += 4) {
      int end = (i + 4 < widget.attendances.length)
          ? i + 4
          : widget.attendances.length;
      rows.add(widget.attendances.sublist(i, end));
    }

    return Column(
      children: rows
          .map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  ...row.map(
                    (attendance) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: _getAttendanceWidget(attendance.state),
                      ),
                    ),
                  ),
                  // Rellenar espacios vacíos si la fila no está completa
                  ...List.generate(
                    4 - row.length,
                    (index) => const Expanded(child: SizedBox()),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _getAttendanceWidget(String state) {
    switch (state.toLowerCase()) {
      case 'attended':
        return optionAssisted();
      case 'permission':
        return optionPermission();
      case 'notattended':
        return optionNotAssisted();
      default:
        return optionNotRegistered();
    }
  }

  Widget optionAssisted() {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        color: Colors.green.shade500,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check, color: Colors.white, size: 24),
    );
  }

  Widget optionNotAssisted() {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        color: Colors.red.shade500,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.close, color: Colors.white, size: 24),
    );
  }

  Widget optionPermission() {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        color: Colors.orange.shade600,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          'P',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget optionNotRegistered() {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
    );
  }
}
