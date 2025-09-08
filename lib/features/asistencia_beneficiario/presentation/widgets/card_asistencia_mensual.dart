import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/widgets/text_normal.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/domain/entities/asistencia_mensual.dart';

class CardMonthlyAttendance extends ConsumerStatefulWidget {
  final MonthlyAttendance attendance;
  final VoidCallback? onTap;
  const CardMonthlyAttendance(this.attendance, {this.onTap, super.key});

  @override
  ConsumerState<CardMonthlyAttendance> createState() =>
      _CardMonthlyAttendanceState();
}

class _CardMonthlyAttendanceState extends ConsumerState<CardMonthlyAttendance> {
  @override
  Widget build(BuildContext context) {
    final formattedDate =
        '${DateFormat('MMMM', 'es_ES').format(DateTime(widget.attendance.year, widget.attendance.month)).toLowerCase()} de ${widget.attendance.year}';

    return InkWell(
      onTap: widget.onTap,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(height: 4),
                      textNormal(
                        widget.attendance.nameGroup,
                        fontWeight: FontWeight.w600,
                        textColor: secondary,
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: textNormal(
                          'Asistencia de $formattedDate',
                          fontWeight: FontWeight.w600,
                          textColor: dark,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
