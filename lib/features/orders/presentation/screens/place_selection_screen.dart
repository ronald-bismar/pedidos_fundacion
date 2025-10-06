// lib/features/orders/presentation/screens/place_selection_screen.dart (ACTUALIZADO - CORREGIDO)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../places/domain/entities/place_entity.dart';
import '../../../groups/domain/entities/group_entity.dart'; 
import '../providers/order_providers.dart';
import '../../domain/entities/order_entity.dart'; 
import 'beneficiaries_list_screen.dart';

class PlaceSelectionScreen extends ConsumerWidget {
  final GroupEntity selectedGroup; 
  final String selectedMonth;     
  final String orderType;        
  final Map<String, OrderEntity> existingPendingOrders; 

  const PlaceSelectionScreen({
    super.key,
    required this.selectedGroup, 
    required this.selectedMonth,
    required this.orderType,
    required this.existingPendingOrders,
  });

  // Método para generar una clave única para un pedido (grupo y lugar)
  String _getOrderKey(String groupId, String placeId) => '${groupId}_$placeId';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placesAsyncValue = ref.watch(placesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Lugar para ${selectedGroup.name}'), 
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: placesAsyncValue.when(
        data: (places) {
          if (places.isEmpty) {
            return const Center(child: Text('No hay lugares disponibles.'));
          }

          return ListView.builder(
            itemCount: places.length,
            itemBuilder: (context, index) {
              final place = places[index];
              final String orderKey = _getOrderKey(selectedGroup.id, place.id);
              final OrderEntity? existingOrder = existingPendingOrders[orderKey];

              String subtitleText = 'Crear nuevo pedido aquí';
              Color subtitleColor = Colors.grey.shade700;
              IconData trailingIcon = Icons.arrow_forward_ios;

              if (existingOrder != null) {
                subtitleText = 'Pedido pendiente: ${existingOrder.totalOrder} personas';
                subtitleColor = Colors.orange;
                trailingIcon = Icons.edit;
              }

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.green, size: 30),
                  title: Text(
                    place.city, 
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    subtitleText,
                    style: TextStyle(color: subtitleColor),
                  ),
                  trailing: Icon(trailingIcon),
                  onTap: () async {
                    final resultOrder = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BeneficiariesListScreen(
                          selectedGroup: selectedGroup,
                          selectedPlace: place,
                
                        ),
                      ),
                    );

                    if (resultOrder != null && resultOrder is OrderEntity) {
                      Navigator.pop(context, resultOrder);
                    }
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error al cargar lugares: $e')),
      ),
    );
  }
}