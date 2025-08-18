import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';

class CardAttendanceBeneficiary extends ConsumerStatefulWidget {
  final Beneficiary beneficiary;
  final Function(bool) onAttendanceSelected;
  const CardAttendanceBeneficiary(
    this.beneficiary, {
    super.key,
    required this.onAttendanceSelected,
  });

  @override
  ConsumerState<CardAttendanceBeneficiary> createState() =>
      _CardAttendanceBeneficiaryState();
}

class _CardAttendanceBeneficiaryState
    extends ConsumerState<CardAttendanceBeneficiary> {
  bool? isAttended;

  @override
  Widget build(BuildContext context) {
    final firstName = widget.beneficiary.name.split(' ')[0];
    final lastName = widget.beneficiary.lastName.split(' ')[0];

    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          children: [
            // First row taking 3/4 of width
            Expanded(
              flex: 3,
              child: subTitle(
                '$firstName $lastName',
                fontWeight: FontWeight.w500,
                textColor: dark,
                textAlign: TextAlign.left,
              ),
            ),
            // Second row taking 1/4 of width
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
    final isSelected = isAttended == true;

    return GestureDetector(
      onTap: () {
        setState(() {
          isAttended = isSelected ? null : true;
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
    final isSelected = isAttended == false;

    return GestureDetector(
      onTap: () {
        setState(() {
          isAttended = isSelected ? null : false;
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
