import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia_beneficiario.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/model/estados_asistencia.dart';

class CardAttendanceBeneficiary extends ConsumerStatefulWidget {
  final AttendanceBeneficiary attendanceBeneficiary;
  final Function(StateAttendance) onAttendanceSelected;
  const CardAttendanceBeneficiary(
    this.attendanceBeneficiary, {
    super.key,
    required this.onAttendanceSelected,
  });

  @override
  ConsumerState<CardAttendanceBeneficiary> createState() =>
      _CardAttendanceBeneficiaryState();
}

class _CardAttendanceBeneficiaryState
    extends ConsumerState<CardAttendanceBeneficiary> {
  @override
  Widget build(BuildContext context) {
    final nameBeneficiary = widget.attendanceBeneficiary.nameBeneficiary;

    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: subTitle(
                nameBeneficiary,
                fontWeight: FontWeight.w500,
                textColor: dark,
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  optionAssisted(),
                  const SizedBox(width: 10),
                  optionNotAssisted(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget optionAssisted() {
    bool isSelected =
        StateAttendance.attended.name == widget.attendanceBeneficiary.state;

    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          log('isSelected optionAssisted: $isSelected');

          widget.attendanceBeneficiary.state = isSelected
              ? StateAttendance.attended.name
              : StateAttendance.notRegistered.name;

          widget.onAttendanceSelected(
            isSelected
                ? StateAttendance.attended
                : StateAttendance.notRegistered,
          );
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade500 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(50),
        ),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 100),
          scale: isSelected ? 1.0 : 0.8,
          child: Icon(
            Icons.check,
            color: isSelected ? white : Colors.grey.shade400,
            size: 30,
          ),
        ),
      ),
    );
  }

  Widget optionNotAssisted() {
    bool isSelected =
        StateAttendance.notAttended.name == widget.attendanceBeneficiary.state;

    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          log('isSelected optionNotAssisted: $isSelected');
          widget.attendanceBeneficiary.state = isSelected
              ? StateAttendance.notAttended.name
              : StateAttendance.notRegistered.name;

          widget.onAttendanceSelected(
            isSelected
                ? StateAttendance.notAttended
                : StateAttendance.notRegistered,
          );
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(50),
        ),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: isSelected ? 1.0 : 0.8,
          child: Icon(
            Icons.close,
            color: isSelected ? white : Colors.grey.shade400,
            size: 30,
          ),
        ),
      ),
    );
  }
}
