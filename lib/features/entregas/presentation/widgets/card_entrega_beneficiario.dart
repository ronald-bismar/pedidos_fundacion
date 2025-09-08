import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/widgets/text_normal.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/beneficio.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/entrega_beneficiario.dart';
import 'package:pedidos_fundacion/features/entregas/presentation/providers/benefits_provider.dart';
import 'package:pedidos_fundacion/toDataDynamic/estados_entrega.dart';

class CardDeliveryBeneficiary extends ConsumerStatefulWidget {
  final DeliveryBeneficiary deliveryBeneficiary;
  final VoidCallback? onTap;
  const CardDeliveryBeneficiary(
    this.onTap,
    this.deliveryBeneficiary, {
    super.key,
  });

  @override
  ConsumerState<CardDeliveryBeneficiary> createState() =>
      _CardDeliveryBeneficiaryState();
}

class _CardDeliveryBeneficiaryState
    extends ConsumerState<CardDeliveryBeneficiary>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _iconRotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _iconRotationAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Color _getStatusColor() {
    switch (widget.deliveryBeneficiary.state.toLowerCase()) {
      case DeliveryStates.DELIVERED:
        return Colors.green;
      case DeliveryStates.NOT_DELIVERED:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final benefitsAsync = ref.watch(
      benefitsProvider(widget.deliveryBeneficiary.idDelivery),
    );

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          // Cabecera de la tarjeta
          InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textNormal(
                          'Beneficiario: ${widget.deliveryBeneficiary.nameBeneficiary}',
                          fontWeight: FontWeight.w600,
                          textColor: dark,
                        ),
                        const SizedBox(height: 4),
                        textNormal(
                          'Cód: ${widget.deliveryBeneficiary.codeBeneficiary}',
                          fontWeight: FontWeight.w500,
                          textColor: primary,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Spacer(),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: textNormal(
                                widget.deliveryBeneficiary.state,
                                textColor: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedBuilder(
                    animation: _iconRotationAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _iconRotationAnimation.value * 3.14159,
                        child: IconButton(
                          onPressed: _toggleExpansion,
                          icon: const Icon(
                            Icons.expand_more,
                            color: primary,
                            size: 24,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Sección expandible de productos
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey, width: 0.3)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: benefitsAsync.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (error, stackTrace) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: textNormal(
                        'Error al cargar productos',
                        textColor: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  data: (benefits) => _buildProductsList(benefits),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(List<Benefit> benefits) {
    if (benefits.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 8),
              textNormal(
                'No hay productos asignados',
                textColor: Colors.grey[600]!,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: textNormal(
            'Productos',
            fontWeight: FontWeight.w600,
            textColor: dark,
          ),
        ),
        ...benefits.map((benefit) => _buildProductItem(benefit)),
      ],
    );
  }

  Widget _buildProductItem(Benefit benefit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, size: 16, color: Colors.green[600]),
          const SizedBox(width: 8),
          Expanded(
            child: textNormal(
              benefit.description,
              fontWeight: FontWeight.w500,
              textColor: dark,
            ),
          ),
        ],
      ),
    );
  }
}
