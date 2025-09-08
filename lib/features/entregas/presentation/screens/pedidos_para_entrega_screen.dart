import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/background.dart';
import 'package:pedidos_fundacion/core/widgets/boton_ancho.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/core/widgets/text_normal.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/presentation/providers/asistencia_mensual_provider.dart';
import 'package:pedidos_fundacion/features/entregas/presentation/screens/agregar_beneficios_screen.dart';
import 'package:pedidos_fundacion/features/entregas/presentation/widgets/card_pedidos_para_entrega.dart';
import 'package:pedidos_fundacion/features/orders/domain/entities/order_entity.dart';

class OrdersByDeliveryScreen extends ConsumerStatefulWidget {
  final String nameDelivery;
  final DateTime dateDelivery;
  const OrdersByDeliveryScreen(
    this.nameDelivery,
    this.dateDelivery, {
    super.key,
  });

  @override
  ConsumerState<OrdersByDeliveryScreen> createState() =>
      _OrdersByDeliveryScreenState();
}

class _OrdersByDeliveryScreenState
    extends ConsumerState<OrdersByDeliveryScreen> {
  final List<Order> selectedOrders = [];

  @override
  Widget build(BuildContext context) {
    return backgroundScreen(
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,

        color: primary,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    title('Selecciona los pedidos'),
                    const SizedBox(height: 20),
                    Expanded(
                      // child: monthlyAttendanceAsyncValue.when(
                      //   loading: () => _loadingState(),

                      //   error: (error, stackTrace) => _errorState(error),

                      //   data: (monthlyAttendances) {
                      //     if (monthlyAttendances.isEmpty) {
                      //       return _emptyState();
                      //     }
                      //     return _loadedState(monthlyAttendances);
                      //   },
                      // ),
                      child: _loadedState(orderExamples),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: BotonAncho(
                      text: "Siguiente",
                      onPressed: _nextStep,
                      marginVertical: 0,
                      marginHorizontal: 0,
                      backgroundColor: secondary,
                      textColor: white,
                      paddingHorizontal: 80,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
          subTitle('Error al cargar los pedidos', fontWeight: FontWeight.w600),
          const SizedBox(height: 8),
          textNormal(error.toString(), textColor: white.withOpacity(0.8)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Refrescar los datos
              ref.invalidate(monthlyAttendanceProvider);
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.white.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          subTitle('No hay pedidos', fontWeight: FontWeight.w600),
          const SizedBox(height: 8),
          textNormal('Aún no se han registrado pedidos'),
        ],
      ),
    );
  }

  Widget _loadedState(List<Order> orders) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(monthlyAttendanceProvider);
      },
      child: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return CardOrderByDelivery(
            orders[index],
            onSelectionChanged: (isSelected) {
              setState(() {
                removeAddOrderSelected(isSelected, orders, index);
              });
            },
          );
        },
      ),
    );
  }

  void removeAddOrderSelected(bool isSelected, List<Order> orders, int index) {
    if (isSelected) {
      selectedOrders.add(orders[index]);
    } else {
      selectedOrders.remove(orders[index]);
    }
  }

  List<Order> orderExamples = [
    Order(
      id: "order_001",
      nameGroup: "Restauradores",
      nameOrder: "Pedido Mes de Marzo",
      dateOrder: DateTime(2025, 3, 19),
      numberBeneficiaries: 20,
    ),

    Order(
      id: "order_002",
      nameGroup: "Triunfadores",
      nameOrder: "Pedido Mes de Marzo",
      dateOrder: DateTime(2025, 3, 12),
      numberBeneficiaries: 20,
    ),

    Order(
      id: "order_003",
      nameGroup: "Triunfadores",
      nameOrder: "Pedido Mes de Marzo",
      dateOrder: DateTime(2025, 3, 10),
      numberBeneficiaries: 20,
    ),

    Order(
      id: "order_004",
      nameGroup: "Restauradores",
      nameOrder: "Pedido Mes de Marzo",
      dateOrder: DateTime(2025, 4, 12),
      numberBeneficiaries: 20,
    ),

    Order(
      id: "order_005",
      nameGroup: "Restauradores",
      nameOrder: "Pedido Mes de Marzo",
      dateOrder: DateTime(2025, 10, 12),
      numberBeneficiaries: 20,
    ),
  ];

  void _nextStep() {
    cambiarPantalla(
      context,
      AddBenefitsScreen(
        widget.nameDelivery,
        widget.dateDelivery,
        selectedOrders,
      ),
    );
  }
}
