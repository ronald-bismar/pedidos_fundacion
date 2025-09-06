import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/core/widgets/text_normal.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/features/orders/domain/entities/order_entity.dart';

class CardOrderByDelivery extends ConsumerStatefulWidget {
  final Order order;
  final Function(bool)?
  onSelectionChanged; // Callback para manejar la selección

  const CardOrderByDelivery(
    this.order, {
    super.key,
    this.onSelectionChanged,
  });

  @override
  ConsumerState<CardOrderByDelivery> createState() =>
      _CardOrdersByDeliveryState();
}

class _CardOrdersByDeliveryState extends ConsumerState<CardOrderByDelivery> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = false;
  }

  void _handleSelectionChange(bool? newValue) {
    setState(() {
      isSelected = newValue ?? false;
    });
    // Notificar al padre sobre el cambio
    widget.onSelectionChanged?.call(isSelected);
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      color: isSelected ? quinary : null,
      child: InkWell(
        onTap: () {
          _handleSelectionChange(!isSelected);
        },
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subTitle(
                      widget.order.nameOrder,
                      fontWeight: FontWeight.w400,
                      textColor: dark,
                    ),
                    const SizedBox(height: 2),
                    textNormal(
                      widget.order.nameGroup,
                      fontWeight: FontWeight.w400,
                      textColor: secondary,
                    ),
                    textNormal(
                      'Fecha del pedido ${dateFormat.format(widget.order.dateOrder)}',
                      fontWeight: FontWeight.w500,
                      textColor: dark.withAlpha(150),
                    ),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: title(
                  widget.order.numberBeneficiaries.toString(),
                  textColor: secondary,
                ),
              ),

              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: isSelected,
                  onChanged: _handleSelectionChange,
                  activeColor: secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  // Evitar que el tap del checkbox interfiera con el de la card
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
