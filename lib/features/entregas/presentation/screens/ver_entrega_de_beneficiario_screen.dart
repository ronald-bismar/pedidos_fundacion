import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/core/widgets/text_normal.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/beneficio.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/entrega_beneficiario.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/producto_beneficiario.dart';
import 'package:pedidos_fundacion/features/entregas/presentation/providers/benefits_provider.dart';
import 'package:pedidos_fundacion/features/entregas/presentation/providers/productos_beneficiario_provider.dart';

class ViewDeliveryBeneficiaryScreen extends ConsumerStatefulWidget {
  final DeliveryBeneficiary deliveryBeneficiary;

  const ViewDeliveryBeneficiaryScreen({
    super.key,
    required this.deliveryBeneficiary,
  });

  @override
  ConsumerState<ViewDeliveryBeneficiaryScreen> createState() =>
      _ViewDeliveryBeneficiaryScreenState();
}

class _ViewDeliveryBeneficiaryScreenState
    extends ConsumerState<ViewDeliveryBeneficiaryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final benefitsAsync = ref.watch(
      benefitsProvider(widget.deliveryBeneficiary.idDelivery),
    );
    final productsAsync = ref.watch(
      productBeneficiaryProvider(widget.deliveryBeneficiary.id),
    );
    final formattedDate = widget.deliveryBeneficiary.deliveryDate != null
        ? DateFormat(
            'dd-MM-yyyy',
          ).format(widget.deliveryBeneficiary.deliveryDate!)
        : 'No registrada';

    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: subTitle(
          'Detalle de la entrega',
          textColor: Colors.white,
          textAlign: TextAlign.start,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              height: double.infinity, // Fuerza la altura completa
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Información de la entrega (contenido fijo)
                    _buildDeliveryInfo(formattedDate),

                    const SizedBox(height: 24),

                    // Foto de la entrega (contenido fijo)
                    _buildDeliveryPhoto(),

                    const SizedBox(height: 24),

                    // Lista de productos con estado (contenido expandible)
                    Expanded(
                      child: _buildProductsSection(
                        benefitsAsync,
                        productsAsync,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryInfo(String formattedDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textNormal(
          'Fecha de entrega $formattedDate',
          textColor: Colors.grey[600]!,
        ),
        const SizedBox(height: 8),
        textNormal(
          'Programa: Triunfadores I',
          textColor: primary,
          fontWeight: FontWeight.w600,
        ),
        textNormal(
          'BO0345456647',
          textColor: primary,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 8),
        textNormal(
          widget.deliveryBeneficiary.nameBeneficiary,
          textColor: Colors.black,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }

  Widget _buildDeliveryPhoto() {
    return Center(
      child: Container(
        width: 200,
        height: 400,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: widget.deliveryBeneficiary.idPhotoDelivery.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: _buildMockPhoto(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  textNormal(
                    'Sin foto registrada',
                    textColor: Colors.grey[600]!,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildMockPhoto() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/ninios.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProductsSection(
    AsyncValue<List<Benefit>> benefitsAsync,
    AsyncValue<List<ProductBeneficiary>> productsAsync,
  ) {
    return benefitsAsync.when(
      loading: () => _buildLoadingProducts(),
      error: (error, _) => _buildErrorProducts(),
      data: (benefits) => productsAsync.when(
        loading: () => _buildProductsList(benefits, []),
        error: (error, _) => _buildProductsList(benefits, []),
        data: (products) => _buildProductsList(benefits, products),
      ),
    );
  }

  Widget _buildLoadingProducts() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorProducts() {
    return Center(
      child: textNormal('Error al cargar productos', textColor: Colors.red),
    );
  }

  Widget _buildProductsList(
    List<Benefit> benefits,
    List<ProductBeneficiary> products,
  ) {
    if (benefits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            textNormal(
              'No hay productos registrados',
              textColor: Colors.grey[600]!,
            ),
          ],
        ),
      );
    }

    return ListView(
      children: benefits.map((benefit) {
        final product = products
            .where((p) => p.idBenefit == benefit.id)
            .firstOrNull;
        final isDelivered =
            product?.isEntregado ?? true; // Por defecto entregado para la vista

        return _buildProductItem(benefit, isDelivered);
      }).toList(),
    );
  }

  Widget _buildProductItem(Benefit benefit, bool isDelivered) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: textNormal(benefit.description, textColor: Colors.black87),
          ),
          const SizedBox(width: 12),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isDelivered ? Colors.green : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: isDelivered
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Icon(Icons.close, color: Colors.grey[600], size: 16),
          ),
        ],
      ),
    );
  }
}
