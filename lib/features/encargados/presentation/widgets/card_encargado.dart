import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/widgets/text_normal.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';
import 'package:pedidos_fundacion/features/beneficiarios/presentation/widgets/image_beneficiary.dart';

class CardCoordinator extends ConsumerStatefulWidget {
  final Coordinator coordinator;
  const CardCoordinator(this.coordinator, {super.key});

  @override
  ConsumerState<CardCoordinator> createState() => _CardCoordinatorState();
}

class _CardCoordinatorState extends ConsumerState<CardCoordinator> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              ImageBeneficiary(widget.coordinator.idPhoto),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 4),
                    textNormal(
                      widget.coordinator.role,
                      fontWeight: FontWeight.w600,
                      textColor: secondary,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: textNormal(
                        '${widget.coordinator.name} ${widget.coordinator.lastName}',
                        fontWeight: FontWeight.w600,
                        textColor: dark,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
