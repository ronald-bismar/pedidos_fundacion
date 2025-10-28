import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/boton_normal.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/core/widgets/text_normal.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/entrega.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/entrega_beneficiario.dart';
import 'package:pedidos_fundacion/features/entregas/presentation/providers/entregas_beneficiarios_providers.dart';
import 'package:pedidos_fundacion/features/entregas/presentation/screens/registrar_entrega_de_beneficiario.dart';
import 'package:pedidos_fundacion/features/entregas/presentation/screens/ver_entrega_de_beneficiario_screen.dart';
import 'package:pedidos_fundacion/features/entregas/presentation/widgets/card_entrega_beneficiario.dart';
import 'package:pedidos_fundacion/toDataDynamic/estados_entrega.dart';

class ListDeliveriesBeneficiaryScreen extends ConsumerStatefulWidget {
  final Delivery delivery;

  const ListDeliveriesBeneficiaryScreen(this.delivery, {super.key});

  @override
  ConsumerState<ListDeliveriesBeneficiaryScreen> createState() =>
      _ListDeliveriesBeneficiaryScreenState();
}

class _ListDeliveriesBeneficiaryScreenState
    extends ConsumerState<ListDeliveriesBeneficiaryScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _listAnimationController;
  late AnimationController _expandController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _expandAnimation;

  int cantidadEntregas = 0;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _listAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _listAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );

    _controller.forward();
    _listAnimationController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _listAnimationController.dispose();
    _expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deliveriesAsyncValue = ref.watch(
      deliveryBeneficiaryByDeliveryProvider(widget.delivery.id),
    );

    final formartDate = DateFormat(
      'MMMM',
      'es_ES',
    ).format(widget.delivery.scheduledDate);
    final month = formartDate[0].toUpperCase() + formartDate.substring(1);

    return Scaffold(
      body: Container(
        color: primary,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              title('Entregas de víveres y ración seca'),

              const SizedBox(height: 10),

              Column(
                children: [
                  subTitle(
                    'Tutor: Lizeth Mamani Cauna',
                    textColor: Colors.white.withOpacity(0.9),
                  ),
                  subTitle(
                    'Grupos: ${widget.delivery.nameGroup}',
                    textColor: Colors.white.withOpacity(0.9),
                  ),
                  subTitle(
                    'Mes: $month',
                    textColor: Colors.white.withOpacity(0.9),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Estadísticas
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatChip('Cantidad: $cantidadEntregas', Colors.blue),
                    BotonNormal(
                      onPressed: () {
                        _showBenefitsToDelivery();
                      },
                      label: 'Productos',
                      textColor: white,
                      buttonColor: secondary,
                    ),
                  ],
                ),
              ),

              // Card expandible de productos
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                height: _isExpanded ? null : 0,
                child: SizeTransition(
                  sizeFactor: _expandAnimation,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Productos incluidos',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primary,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _toggleExpansion();
                              },
                              icon: AnimatedRotation(
                                turns: _isExpanded ? 0.5 : 0,
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildProductsList(),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: deliveriesAsyncValue.when(
                  loading: () => _loadingState(),
                  error: (error, stackTrace) => _errorState(error),
                  data: (deliveries) {
                    if (deliveries.isEmpty) {
                      return _emptyState();
                    }
                    cantidadEntregas = deliveries.length;
                    return _loadedState(deliveries);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductsList() {
    // Lista de ejemplo de productos - puedes reemplazar con datos reales
    final products = [
      {'name': 'Arroz', 'quantity': '2 kg', 'icon': Icons.rice_bowl},
      {'name': 'Frijoles', 'quantity': '1 kg', 'icon': Icons.grain},
      {'name': 'Aceite', 'quantity': '1 lt', 'icon': Icons.local_drink},
      {'name': 'Azúcar', 'quantity': '1 kg', 'icon': Icons.cake},
      {'name': 'Leche en polvo', 'quantity': '500 g', 'icon': Icons.local_cafe},
    ];

    return Column(
      children: products.map((product) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Icon(product['icon'] as IconData, color: primary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  product['name'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                product['quantity'] as String,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: textNormal(
        text,
        textColor: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _loadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            'Cargando entregas...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _errorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          subTitle('Error al cargar entregas', fontWeight: FontWeight.w600),
          const SizedBox(height: 8),
          textNormal(
            'Ha ocurrido un error al cargar los datos',
            textColor: white.withOpacity(0.8),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.invalidate(
                deliveryBeneficiaryByDeliveryProvider(widget.delivery.id),
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _listAnimationController,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                size: 64,
                color: Colors.white.withOpacity(0.6),
              ),
              const SizedBox(height: 16),
              subTitle('No hay entregas', fontWeight: FontWeight.w600),
              const SizedBox(height: 8),
              textNormal(
                'No se encontraron entregas a beneficiarios',
                textColor: white.withOpacity(0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loadedState(List<DeliveryBeneficiary> deliveries) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _listAnimationController,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(
              deliveryBeneficiaryByDeliveryProvider(widget.delivery.id),
            );
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: deliveries.length,
            itemBuilder: (context, index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 200 + (index * 50)),
                curve: Curves.easeOutBack,
                child: CardDeliveryBeneficiary(() {
                  if (deliveries[index].state == DeliveryStates.DELIVERED) {
                    cambiarPantalla(
                      context,
                      ViewDeliveryBeneficiaryScreen(
                        deliveryBeneficiary: deliveries[index],
                      ),
                    );
                  } else {
                    cambiarPantalla(
                      context,
                      RegisterDeliveryBeneficiaryScreen(
                        deliveryBeneficiary: deliveries[index],
                      ),
                    );
                  }
                }, deliveries[index]),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showBenefitsToDelivery() {
    _controller.forward(from: 0.0);
    _toggleExpansion();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }
}
