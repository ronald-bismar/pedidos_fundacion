import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/core/widgets/text_normal.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/entrega.dart';

class CardDelivery extends ConsumerStatefulWidget {
  final Delivery delivery;
  final VoidCallback? onTap;
  const CardDelivery(this.delivery, {this.onTap, super.key});

  @override
  ConsumerState<CardDelivery> createState() => _CardCoordinatorState();
}

class _CardCoordinatorState extends ConsumerState<CardDelivery> {
  @override
  Widget build(BuildContext context) {
    final formattedDate =
        '${DateFormat('MMMM', 'es_ES').format(DateTime(widget.delivery.scheduledDate.year, widget.delivery.scheduledDate.month)).toLowerCase()} de ${widget.delivery.scheduledDate.year}';

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(height: 4),
                      subTitle(
                        widget.delivery.nameGroup,
                        fontWeight: FontWeight.w400,
                        textColor: secondary,
                      ),
                      const SizedBox(height: 4),
                      textNormal(
                        widget.delivery.nameDelivery,
                        fontWeight: FontWeight.w500,
                        textColor: dark,
                      ),
                      const SizedBox(height: 4),
                      textNormal(
                        formattedDate,
                        fontWeight: FontWeight.w500,
                        textColor: dark.withAlpha(150),
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
