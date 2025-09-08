import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/beneficio.dart';

// Provider para obtener beneficios por ID de entrega
final benefitsProvider = FutureProvider.family<List<Benefit>, String>((
  ref,
  deliveryId,
) async {
  // Simular carga de datos - aquí iría la llamada a tu API o base de datos
  await Future.delayed(const Duration(milliseconds: 500));

  // Retornar beneficios de ejemplo basados en el deliveryId
  return _getMockBenefits(deliveryId);
});

// Datos de ejemplo para beneficios
List<Benefit> _getMockBenefits(String deliveryId) {
  final Map<String, List<Benefit>> benefitsByDelivery = {
    'delivery-001': [
      Benefit(
        id: 'benefit-001',
        type: 'Alimento',
        description: '1 Unid de Azúcar Blanca de 5 kg',
        idDelivery: 'delivery-001',
      ),
      Benefit(
        id: 'benefit-002',
        type: 'Alimento',
        description: '1 Unid de Harina de 1 kg',
        idDelivery: 'delivery-001',
      ),
      Benefit(
        id: 'benefit-003',
        type: 'Lácteo',
        description: '1 Unid de Leche Kream Natural 946 ml',
        idDelivery: 'delivery-001',
      ),
      Benefit(
        id: 'benefit-004',
        type: 'Aceite',
        description: '1 Unid de Aceite Borges de 227 g',
        idDelivery: 'delivery-001',
      ),
    ],
    'delivery-002': [
      Benefit(
        id: 'benefit-005',
        type: 'Alimento',
        description: '2 Unid de Arroz de 1 kg',
        idDelivery: 'delivery-002',
      ),
      Benefit(
        id: 'benefit-006',
        type: 'Proteína',
        description: '1 Unid de Atún en lata',
        idDelivery: 'delivery-002',
      ),
      Benefit(
        id: 'benefit-007',
        type: 'Condimento',
        description: '1 Unid de Sal de 1 kg',
        idDelivery: 'delivery-002',
      ),
    ],
    'delivery-003': [
      Benefit(
        id: 'benefit-008',
        type: 'Bebida',
        description: '1 Unid de Jugo Natural de 1 L',
        idDelivery: 'delivery-003',
      ),
      Benefit(
        id: 'benefit-009',
        type: 'Alimento',
        description: '1 Unid de Pasta de 500g',
        idDelivery: 'delivery-003',
      ),
    ],
    'delivery-004': [
      Benefit(
        id: 'benefit-010',
        type: 'Higiene',
        description: '1 Unid de Jabón de tocador',
        idDelivery: 'delivery-004',
      ),
      Benefit(
        id: 'benefit-011',
        type: 'Limpieza',
        description: '1 Unid de Detergente en polvo 500g',
        idDelivery: 'delivery-004',
      ),
      Benefit(
        id: 'benefit-012',
        type: 'Alimento',
        description: '1 Unid de Frijoles de 1 kg',
        idDelivery: 'delivery-004',
      ),
    ],
    'delivery-005': [
      Benefit(
        id: 'benefit-013',
        type: 'Alimento',
        description: '1 Unid de Quinua de 500g',
        idDelivery: 'delivery-005',
      ),
    ],
  };

  return benefitsByDelivery[deliveryId] ?? [];
}

// Provider para obtener todos los beneficios
final allBenefitsProvider = FutureProvider<List<Benefit>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 300));

  List<Benefit> allBenefits = [];
  final deliveryIds = [
    'delivery-001',
    'delivery-002',
    'delivery-003',
    'delivery-004',
    'delivery-005',
  ];

  for (String deliveryId in deliveryIds) {
    allBenefits.addAll(_getMockBenefits(deliveryId));
  }

  return allBenefits;
});
