// lib/features/orders/presentation/pages/orders_by_delivery_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/background.dart';
import 'package:pedidos_fundacion/core/widgets/boton_ancho.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/core/widgets/text_normal.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
// <<-- Reemplazar este por un provider de pedidos si es necesario -->>
// import 'package:pedidos_fundacion/features/asistencia_beneficiario/presentation/providers/asistencia_mensual_provider.dart';
import 'package:pedidos_fundacion/features/entregas/presentation/screens/agregar_beneficios_screen.dart';
import 'package:pedidos_fundacion/features/entregas/presentation/widgets/card_pedidos_para_entrega.dart';
import 'package:pedidos_fundacion/features/orders/domain/entities/order_entity.dart';
import 'package:pedidos_fundacion/features/orders/domain/entities/order_state.dart';

// Clase para encapsular una OrderEntity con un estado de selección
class SelectableOrder {
  final OrderEntity order;
  bool isSelected;

  SelectableOrder({required this.order, this.isSelected = false});
}

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
  // Lista para manejar el estado de selección de todas las órdenes
  List<SelectableOrder> _selectableOrders = [];
  bool _isInitialized = false; // Para inicializar _selectableOrders una sola vez

  // Lista de solo las OrderEntity seleccionadas que se pasarán a la siguiente pantalla
  List<OrderEntity> get _selectedOrdersEntities =>
      _selectableOrders.where((so) => so.isSelected).map((so) => so.order).toList();

  @override
  Widget build(BuildContext context) {
    // <<-- USANDO UN PROVIDER DE ÓRDENES -->>
    // Asumo que tienes un 'ordersByStatusProvider' o similar que filtra por el estado adecuado
    // para ser seleccionadas en una entrega (por ejemplo, PENDING o ACTIVE).
    // Si no, podrías usar un 'allOrdersStreamProvider' y filtrar aquí.
    final ordersAsyncValue = ref.watch(ordersReadyForDeliveryProvider); // <<-- Nuevo Provider para órdenes aptas

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
                      child: ordersAsyncValue.when(
                        data: (orders) {
                          // Inicializar _selectableOrders solo una vez cuando los datos llegan
                          if (!_isInitialized) {
                            _selectableOrders = orders.map((order) =>
                                SelectableOrder(order: order, isSelected: false))
                                .toList();
                            _isInitialized = true;
                          }
                          return _loadedState(_selectableOrders);
                        },
                        loading: () => _loadingState(),
                        error: (e, s) => _errorState(e),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: BotonAncho(
                      text: "Siguiente (${_selectedOrdersEntities.length} seleccionados)", // Muestra cuántos están seleccionados
                      onPressed: _nextStep,
                      marginVertical: 0,
                      marginHorizontal: 0,
                      backgroundColor: _selectedOrdersEntities.isEmpty ? Colors.grey : secondary, // Deshabilita si no hay seleccionados
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
              ref.invalidate(ordersReadyForDeliveryProvider); // <<-- Invalidar el provider correcto
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
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_shipping_outlined, // Icono más relevante para pedidos
            size: 64,
            color: Colors.white.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          subTitle('No hay pedidos disponibles', fontWeight: FontWeight.w600), // Texto actualizado
          const SizedBox(height: 8),
          textNormal('No se encontraron pedidos en estado "Pendiente" o "Activo".'),
        ],
      ),
    );
  }

  // Ahora recibe List<SelectableOrder>
  Widget _loadedState(List<SelectableOrder> selectableOrders) {
    if (selectableOrders.isEmpty) {
      return _emptyState();
    }
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(ordersReadyForDeliveryProvider); // <<-- Invalidar el provider correcto
        _isInitialized = false; // Reinicializar al refrescar
      },
      child: ListView.builder(
        itemCount: selectableOrders.length,
        itemBuilder: (context, index) {
          final selectableOrder = selectableOrders[index];
          return CardOrderByDelivery(
            selectableOrder.order,
            initialIsSelected: selectableOrder.isSelected, // Pasamos el estado inicial de selección
            onSelectionChanged: (isSelected) {
              setState(() {
                selectableOrder.isSelected = isSelected; // Actualizamos el estado de la orden seleccionable
              });
            },
          );
        },
      ),
    );
  }

  void _nextStep() {
    // Asegurarse de que al menos una orden esté seleccionada
    if (_selectedOrdersEntities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona al menos un pedido para continuar.')),
      );
      return;
    }

    cambiarPantalla(
      context,
      AddBenefitsScreen(
        widget.nameDelivery,
        widget.dateDelivery,
        _selectedOrdersEntities, // Pasamos solo las OrderEntity seleccionadas
      ),
    );
  }
}

// <<-- ASUMIMOS QUE ESTE ES TU PROVIDER PARA ÓRDENES APTAS PARA ENTREGA -->>
// Necesitarás definirlo en un archivo como 'lib/features/orders/presentation/providers/order_provider.dart'
// Este es un ejemplo, ajusta según tu repositorio/datasource real.
final ordersReadyForDeliveryProvider = StreamProvider<List<OrderEntity>>((ref) {
  // Aquí obtendrías un Stream de órdenes que están en estado 'pending' o 'active'
  // Puedes usar tu OrderRepository o un UseCase para esto.
  // Por ahora, usaremos datos de ejemplo con los nuevos campos
  // En una aplicación real, esto vendría de tu capa de datos (Firestore, etc.)
  return Stream.value([
    OrderEntity(
      id: "order_001",
      nameuser: "Usuario 1",
      nameTutor: "María García",
      nameGroup: "Restauradores",
      namePlace: "Sede Centro",
      nameOrder: "Pedido Semanal 1",
      dateOrderMonth: "Enero",
      dateOrderDay: "10",
      dateOrderYear: "2024",
      beneficiaryCount: 15,
      nonBeneficiaryCount: 5,
      observedBeneficiaryCount: 2,
      totalOrder: 15000,
      itemQuantities: {"Arroz": 5, "Frijoles": 3},
      observations: "Notas adicionales del pedido 1.",
      state: OrderState.pending, // Apto para selección
      placeId: "place_abc",
      groupId: "group_restauradores",
      registrationDate: DateTime(2024, 1, 5, 10, 0),
      lastModifiedDate: DateTime(2024, 1, 8, 14, 30),
    ),
    OrderEntity(
      id: "order_002",
      nameuser: "Usuario 2",
      nameTutor: "Juan Pérez",
      nameGroup: "Triunfadores",
      namePlace: "Sede Norte",
      nameOrder: "Pedido Semanal 2",
      dateOrderMonth: "Enero",
      dateOrderDay: "12",
      dateOrderYear: "2024",
      beneficiaryCount: 20,
      nonBeneficiaryCount: 0,
      observedBeneficiaryCount: 0,
      totalOrder: 20000,
      itemQuantities: {"Leche": 10, "Pan": 20},
      observations: "",
      state: OrderState.active, // Apto para selección
      placeId: "place_xyz",
      groupId: "group_triunfadores",
      registrationDate: DateTime(2024, 1, 7, 9, 0),
      lastModifiedDate: DateTime(2024, 1, 10, 11, 0),
    ),
    OrderEntity(
      id: "order_003",
      nameuser: "Usuario 3",
      nameTutor: "Ana López",
      nameGroup: "Caminantes",
      namePlace: "Sede Sur",
      nameOrder: "Pedido Especial",
      dateOrderMonth: "Febrero",
      dateOrderDay: "15",
      dateOrderYear: "2024",
      beneficiaryCount: 10,
      nonBeneficiaryCount: 2,
      observedBeneficiaryCount: 1,
      totalOrder: 12000,
      itemQuantities: {"Cereal": 2, "Huevos": 3},
      observations: "Entrega urgente.",
      state: OrderState.processed, // No apto para selección, no aparecerá por defecto si el provider filtra
      placeId: "place_mno",
      groupId: "group_caminantes",
      registrationDate: DateTime(2024, 2, 1, 13, 0),
      lastModifiedDate: DateTime(2024, 2, 10, 16, 0),
    ),
  ]);
});

// <<-- EJEMPLO DE CardOrderByDelivery -->>
// Necesitarás definir esta clase en 'lib/features/entregas/presentation/widgets/card_pedidos_para_entrega.dart'
// para que el código compile. Es una versión simplificada de OrderListItem.
class CardOrderByDelivery extends StatefulWidget {
  final OrderEntity order;
  final ValueChanged<bool> onSelectionChanged;
  final bool initialIsSelected; // Nuevo parámetro para el estado inicial

  const CardOrderByDelivery(
    this.order, {
    super.key,
    required this.onSelectionChanged,
    this.initialIsSelected = false,
  });

  @override
  State<CardOrderByDelivery> createState() => _CardOrderByDeliveryState();
}

class _CardOrderByDeliveryState extends State<CardOrderByDelivery> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.initialIsSelected; // Usa el estado inicial
  }

  @override
  Widget build(BuildContext context) {
    // Para simplificar, el color de la tarjeta puede depender solo de la selección.
    // O puedes mantener la lógica de statusColor como en OrderListItem si lo prefieres.
    Color cardColor = _isSelected ? primary.withBlue(200) : Colors.white;
    Color textColor = _isSelected ? primary.withBlue(200) : Colors.black87;
    Color subtitleColor = _isSelected ? primary.withBlue(200) : Colors.grey.shade600;

    // Formatear el total
    final formattedTotal = widget.order.totalOrder.toDouble().toStringAsFixed(2);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      elevation: _isSelected ? 4 : 2, // Más elevación si está seleccionada
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _isSelected ? secondary : Colors.grey.shade300, // Borde más distintivo
          width: _isSelected ? 2 : 1.5,
        ),
      ),
      color: cardColor,
      child: InkWell( // Hace que toda la tarjeta sea clickable para la selección
        onTap: () {
          setState(() {
            _isSelected = !_isSelected;
            widget.onSelectionChanged(_isSelected);
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: _isSelected ? secondary : Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Pedido: ${widget.order.nameOrder}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 15, thickness: 0.5),
              Text('Tutor: ${widget.order.nameTutor}', style: TextStyle(fontSize: 13, color: subtitleColor)),
              Text('Grupo: ${widget.order.nameGroup}', style: TextStyle(fontSize: 13, color: subtitleColor)),
              Text('Fecha: ${widget.order.dateOrderDay}/${widget.order.dateOrderMonth.split(' ')[0]} ${widget.order.dateOrderYear}', style: TextStyle(fontSize: 13, color: subtitleColor)),
              Text('Beneficiarios: ${widget.order.beneficiaryCount}', style: TextStyle(fontSize: 13, color: subtitleColor)),
              Text('Total: \$${formattedTotal}', style: TextStyle(fontSize: 13, color: textColor, fontWeight: FontWeight.bold)),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.order.state == OrderState.active ? Colors.indigo.shade100 : Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.order.state.displayName,
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.order.state == OrderState.active ? Colors.indigo.shade800 : Colors.blue.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}