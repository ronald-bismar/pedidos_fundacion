import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/entrega_beneficiario.dart';
import 'package:pedidos_fundacion/toDataDynamic/estados_entrega.dart';

final deliveryBeneficiaryByDeliveryProvider =
    FutureProvider.family<List<DeliveryBeneficiary>, String>((
      ref,
      deliveryId,
    ) async {
      await Future.delayed(const Duration(milliseconds: 500));

      final allDeliveries = _getMockDeliveryBeneficiaries();
      return allDeliveries
          .where((delivery) => delivery.idDelivery == deliveryId)
          .toList();
    });

List<DeliveryBeneficiary> _getMockDeliveryBeneficiaries() {
  return [
    DeliveryBeneficiary(
      id: 'db-001',
      codeBeneficiary: 'BG-016',
      nameBeneficiary: 'Carlos Arquelipa Pinto',
      state: DeliveryStates.DELIVERED,
      idPhotoDelivery: 'photo-001',
      deliveryDate: DateTime.now().subtract(const Duration(days: 1)),
      idDelivery: 'delivery-001',
    ),
    DeliveryBeneficiary(
      id: 'db-002',
      codeBeneficiary: 'BG-036',
      nameBeneficiary: 'Cristian Mamani',
      state: DeliveryStates.NOT_DELIVERED,
      idPhotoDelivery: '',
      deliveryDate: null,
      idDelivery: 'delivery-002',
    ),
    DeliveryBeneficiary(
      id: 'db-003',
      codeBeneficiary: 'BG-120',
      nameBeneficiary: 'Dorian Pinto',
      state: DeliveryStates.DELIVERED,
      idPhotoDelivery: 'photo-003',
      deliveryDate: DateTime.now().subtract(const Duration(hours: 3)),
      idDelivery: 'delivery-001',
    ),
    DeliveryBeneficiary(
      id: 'db-004',
      codeBeneficiary: 'BG-233',
      nameBeneficiary: 'Alexander Robles',
      state: DeliveryStates.NOT_DELIVERED,
      idPhotoDelivery: '',
      deliveryDate: null,
      idDelivery: 'delivery-003',
    ),
    DeliveryBeneficiary(
      id: 'db-005',
      codeBeneficiary: 'BG-260',
      nameBeneficiary: 'Pedro Pinto',
      state: DeliveryStates.NOT_DELIVERED,
      idPhotoDelivery: '',
      deliveryDate: null,
      idDelivery: 'delivery-004',
    ),
    DeliveryBeneficiary(
      id: 'db-006',
      codeBeneficiary: 'BG-287',
      nameBeneficiary: 'María González',
      state: DeliveryStates.DELIVERED,
      idPhotoDelivery: 'photo-006',
      deliveryDate: DateTime.now().subtract(const Duration(days: 2)),
      idDelivery: 'delivery-002',
    ),
    DeliveryBeneficiary(
      id: 'db-007',
      codeBeneficiary: 'BG-298',
      nameBeneficiary: 'Ana López',
      state:DeliveryStates.DELIVERED,
      idPhotoDelivery: '',
      deliveryDate: null,
      idDelivery: 'delivery-005',
    ),
    DeliveryBeneficiary(
      id: 'db-008',
      codeBeneficiary: 'BG-315',
      nameBeneficiary: 'José Mamani',
      state: DeliveryStates.DELIVERED,
      idPhotoDelivery: 'photo-008',
      deliveryDate: DateTime.now().subtract(const Duration(hours: 5)),
      idDelivery: 'delivery-001',
    ),
    DeliveryBeneficiary(
      id: 'db-009',
      codeBeneficiary: 'BG-342',
      nameBeneficiary: 'Lucia Vargas',
      state: DeliveryStates.NOT_DELIVERED,
      idPhotoDelivery: '',
      deliveryDate: null,
      idDelivery: 'delivery-003',
    ),
    DeliveryBeneficiary(
      id: 'db-010',
      codeBeneficiary: 'BG-358',
      nameBeneficiary: 'Roberto Silva',
      state: DeliveryStates.NOT_DELIVERED,
      idPhotoDelivery: '',
      deliveryDate: null,
      idDelivery: 'delivery-004',
    ),
  ];
}
