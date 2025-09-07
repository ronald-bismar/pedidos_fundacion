import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/entrega.dart';

final deliveriesProvider = StreamProvider<List<Delivery>>((ref) {
  // final deliveryRepository = ref.watch(deliveryRepoProvider);
  // return deliveryRepository.getDeliveriesByGroups();
  return Stream.value(_getMockDeliveries());
});
// Datos de ejemplo que coinciden con el diseño mostrado
List<Delivery> _getMockDeliveries() {
  return [
    // Grupo Triunfadores - Entrega de víveres y ración seca (Mayo 2025)
    Delivery(
      id: 'delivery-001',
      nameDelivery: 'Entrega de víveres y ración seca',
      scheduledDate: DateTime(2025, 5, 15),
      idGroup: 'group-001',
      nameGroup: 'Grupo Triunfadores',
      foundation: 'Fundación Compassion',
      type: 'Víveres y Ración Seca',
      idCoordinator: 'coord-001',
      updatedAt: DateTime.now(),
    ),

    // Grupo Descubridores - Entrega de material escolar (Mayo 2025)
    Delivery(
      id: 'delivery-002',
      nameDelivery: 'Entrega de material escolar',
      scheduledDate: DateTime(2025, 5, 20),
      idGroup: 'group-002',
      nameGroup: 'Grupo Descubridores',
      foundation: 'Fundación Compassion',
      type: 'Material Escolar',
      idCoordinator: 'coord-002',
      updatedAt: DateTime.now(),
    ),

    // Grupo Restauradores - Entrega de víveres y ración seca (Mayo 2025)
    Delivery(
      id: 'delivery-003',
      nameDelivery: 'Entrega de víveres y ración seca',
      scheduledDate: DateTime(2025, 5, 25),
      idGroup: 'group-003',
      nameGroup: 'Grupo Restauradores',
      foundation: 'Fundación Compassion',
      type: 'Víveres y Ración Seca',
      idCoordinator: 'coord-003',
      updatedAt: DateTime.now(),
    ),

    // Grupo Pre GAP - Entrega de víveres y ración seca (Mayo 2025)
    Delivery(
      id: 'delivery-004',
      nameDelivery: 'Entrega de víveres y ración seca',
      scheduledDate: DateTime(2025, 5, 30),
      idGroup: 'group-004',
      nameGroup: 'Grupo Pre GAP',
      foundation: 'Fundación Compassion',
      type: 'Víveres y Ración Seca',
      idCoordinator: 'coord-004',
      updatedAt: DateTime.now(),
    ),

    // Grupo Triunfadores - Entrega anterior (Abril 2025)
    Delivery(
      id: 'delivery-005',
      nameDelivery: 'Entrega de víveres y ración seca',
      scheduledDate: DateTime(2025, 4, 15),
      idGroup: 'group-001',
      nameGroup: 'Grupo Triunfadores',
      foundation: 'Fundación Compassion',
      type: 'Víveres y Ración Seca',
      idCoordinator: 'coord-001',
      updatedAt: DateTime.now(),
    ),

    // Entregas adicionales para otros meses y grupos
    Delivery(
      id: 'delivery-006',
      nameDelivery: 'Entrega de kit de higiene',
      scheduledDate: DateTime(2025, 6, 10),
      idGroup: 'group-005',
      nameGroup: 'Grupo Esperanza',
      foundation: 'Fundación Compassion',
      type: 'Kit de Higiene',
      idCoordinator: 'coord-005',
      updatedAt: DateTime.now(),
    ),

    Delivery(
      id: 'delivery-007',
      nameDelivery: 'Entrega de complemento nutricional',
      scheduledDate: DateTime(2025, 6, 15),
      idGroup: 'group-006',
      nameGroup: 'Grupo Victoriosos',
      foundation: 'Fundación Compassion',
      type: 'Complemento Nutricional',
      idCoordinator: 'coord-006',
      updatedAt: DateTime.now(),
    ),

    Delivery(
      id: 'delivery-008',
      nameDelivery: 'Entrega de útiles escolares',
      scheduledDate: DateTime(2025, 3, 20),
      idGroup: 'group-002',
      nameGroup: 'Grupo Descubridores',
      foundation: 'Fundación Compassion',
      type: 'Útiles Escolares',
      idCoordinator: 'coord-002',
      updatedAt: DateTime.now(),
    ),

    Delivery(
      id: 'delivery-009',
      nameDelivery: 'Entrega especial de navidad',
      scheduledDate: DateTime(2024, 12, 20),
      idGroup: 'group-007',
      nameGroup: 'Grupo Bendecidos',
      foundation: 'Fundación Compassion',
      type: 'Especial Navideña',
      idCoordinator: 'coord-007',
      updatedAt: DateTime.now(),
    ),

    Delivery(
      id: 'delivery-010',
      nameDelivery: 'Entrega de medicamentos básicos',
      scheduledDate: DateTime(2025, 7, 5),
      idGroup: 'group-008',
      nameGroup: 'Grupo Sanadores',
      foundation: 'Fundación Compassion',
      type: 'Medicamentos Básicos',
      idCoordinator: 'coord-008',
      updatedAt: DateTime.now(),
    ),
  ];
}
