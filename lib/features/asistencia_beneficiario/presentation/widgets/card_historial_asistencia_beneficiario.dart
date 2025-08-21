import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';

class CardHistoryAttendanceBeneficiary extends ConsumerStatefulWidget {
  final Beneficiary beneficiary;
  const CardHistoryAttendanceBeneficiary(this.beneficiary, {super.key});

  @override
  ConsumerState<CardHistoryAttendanceBeneficiary> createState() =>
      _CardHistoryAttendanceBeneficiaryState();
}

class _CardHistoryAttendanceBeneficiaryState
    extends ConsumerState<CardHistoryAttendanceBeneficiary> {
  bool? isAttended;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                subTitle(
                  '${widget.beneficiary.name} ${widget.beneficiary.lastName}',
                  fontWeight: FontWeight.w500,
                  textColor: dark,
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    optionAssisted(),
                    const SizedBox(width: 10),
                    optionNotAssisted(),
                    const SizedBox(width: 10),
                    optionAssisted(),
                    const SizedBox(width: 10),
                    optionNotAssisted(),
                  ],
                ),
              ],
            ),
          ),
        ),
        Divider(color: Colors.grey.shade300, thickness: 1, height: 1),
      ],
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
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade500 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          Icons.check,
          color: isSelected ? white : Colors.grey.shade400,
          size: 25,
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
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          Icons.close,
          color: isSelected ? white : Colors.grey.shade400,
          size: 25,
        ),
      ),
    );
  }
}
