import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/producto_beneficiario.dart';

// Provider para obtener productos de beneficiario por ID de entrega de beneficiario
final productBeneficiaryProvider =
    FutureProvider.family<List<ProductBeneficiary>, String>((
      ref,
      deliveryBeneficiaryId,
    ) async {
      // Simular carga de datos
      await Future.delayed(const Duration(milliseconds: 400));

      return _getMockProductBeneficiaries(deliveryBeneficiaryId);
    });

// Provider para crear/actualizar productos de beneficiario
final productBeneficiaryStateProvider =
    StateNotifierProvider<
      ProductBeneficiaryNotifier,
      AsyncValue<List<ProductBeneficiary>>
    >((ref) => ProductBeneficiaryNotifier());

class ProductBeneficiaryNotifier
    extends StateNotifier<AsyncValue<List<ProductBeneficiary>>> {
  ProductBeneficiaryNotifier() : super(const AsyncValue.loading());

  // Cargar productos para un beneficiario específico
  Future<void> loadProducts(String deliveryBeneficiaryId) async {
    state = const AsyncValue.loading();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final products = _getMockProductBeneficiaries(deliveryBeneficiaryId);
      state = AsyncValue.data(products);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // Actualizar el estado de un producto
  Future<void> updateProductState(String productId, String newState) async {
    final currentState = state;
    if (currentState is AsyncData<List<ProductBeneficiary>>) {
      final products = currentState.value;
      final updatedProducts = products.map((product) {
        if (product.id == productId) {
          return product.copyWith(estado: newState);
        }
        return product;
      }).toList();

      state = AsyncValue.data(updatedProducts);

      // Simular llamada a API
      try {
        await Future.delayed(const Duration(milliseconds: 300));
        // Aquí iría la llamada real a tu API
      } catch (error, stackTrace) {
        // En caso de error, revertir el cambio
        state = currentState;
        rethrow;
      }
    }
  }

  // Crear productos para un beneficiario basado en los beneficios disponibles
  Future<void> createProductsForBeneficiary(
    String deliveryBeneficiaryId,
    List<String> benefitIds,
    Map<String, bool> productStates,
  ) async {
    try {
      state = const AsyncValue.loading();

      final List<ProductBeneficiary> newProducts = [];

      for (String benefitId in benefitIds) {
        final isDelivered = productStates[benefitId] ?? false;

        newProducts.add(
          ProductBeneficiary(
            id: 'prod_${DateTime.now().millisecondsSinceEpoch}_$benefitId',
            idBenefit: benefitId,
            state: isDelivered ? 'Entregado' : 'No Entregado',
            idDeliveryBeneficiary: deliveryBeneficiaryId,
          ),
        );
      }

      // Simular guardado en API
      await Future.delayed(const Duration(milliseconds: 800));

      state = AsyncValue.data(newProducts);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // Marcar todos los productos como entregados
  Future<void> markAllAsDelivered() async {
    final currentState = state;
    if (currentState is AsyncData<List<ProductBeneficiary>>) {
      final products = currentState.value;
      final updatedProducts = products.map((product) {
        product.marcarComoEntregado();
        return product;
      }).toList();

      state = AsyncValue.data(updatedProducts);

      try {
        await Future.delayed(const Duration(milliseconds: 500));
        // Llamada a API
      } catch (error, stackTrace) {
        state = currentState;
        rethrow;
      }
    }
  }

  // Obtener estadísticas de productos
  Map<String, int> getProductStats() {
    final currentState = state;
    if (currentState is AsyncData<List<ProductBeneficiary>>) {
      final products = currentState.value;
      return {
        'total': products.length,
        'entregado': products.where((p) => p.isEntregado).length,
        'no_entregado': products.where((p) => p.isNoEntregado).length,
      };
    }
    return {'total': 0, 'entregado': 0, 'no_entregado': 0};
  }
}

// Datos de ejemplo para productos de beneficiarios
List<ProductBeneficiary> _getMockProductBeneficiaries(
  String deliveryBeneficiaryId,
) {
  final Map<String, List<ProductBeneficiary>> productsByDelivery = {
    'db-001': [
      // Carlos Arquelipa Pinto
      ProductBeneficiary(
        id: 'pb-001',
        idBenefit: 'benefit-001',
        state: 'Entregado',
        idDeliveryBeneficiary: 'db-001',
      ),
      ProductBeneficiary(
        id: 'pb-002',
        idBenefit: 'benefit-002',
        state: 'Entregado',
        idDeliveryBeneficiary: 'db-001',
      ),
      ProductBeneficiary(
        id: 'pb-003',
        idBenefit: 'benefit-003',
        state: 'Entregado',
        idDeliveryBeneficiary: 'db-001',
      ),
      ProductBeneficiary(
        id: 'pb-004',
        idBenefit: 'benefit-004',
        state: 'Entregado',
        idDeliveryBeneficiary: 'db-001',
      ),
    ],
    'db-002': [
      // Cristian Mamani
      ProductBeneficiary(
        id: 'pb-005',
        idBenefit: 'benefit-005',
        state: 'No Entregado',
        idDeliveryBeneficiary: 'db-002',
      ),
      ProductBeneficiary(
        id: 'pb-006',
        idBenefit: 'benefit-006',
        state: 'No Entregado',
        idDeliveryBeneficiary: 'db-002',
      ),
      ProductBeneficiary(
        id: 'pb-007',
        idBenefit: 'benefit-007',
        state: 'No Entregado',
        idDeliveryBeneficiary: 'db-002',
      ),
    ],
    'db-003': [
      // Dorian Pinto
      ProductBeneficiary(
        id: 'pb-008',
        idBenefit: 'benefit-001',
        state: 'Entregado',
        idDeliveryBeneficiary: 'db-003',
      ),
      ProductBeneficiary(
        id: 'pb-009',
        idBenefit: 'benefit-002',
        state: 'Entregado',
        idDeliveryBeneficiary: 'db-003',
      ),
      ProductBeneficiary(
        id: 'pb-010',
        idBenefit: 'benefit-003',
        state: 'Entregado',
        idDeliveryBeneficiary: 'db-003',
      ),
      ProductBeneficiary(
        id: 'pb-011',
        idBenefit: 'benefit-004',
        state: 'No Entregado',
        idDeliveryBeneficiary: 'db-003',
      ),
    ],
    'db-004': [
      // Alexander Robles
      ProductBeneficiary(
        id: 'pb-012',
        idBenefit: 'benefit-008',
        state: 'No Entregado',
        idDeliveryBeneficiary: 'db-004',
      ),
      ProductBeneficiary(
        id: 'pb-013',
        idBenefit: 'benefit-009',
        state: 'No Entregado',
        idDeliveryBeneficiary: 'db-004',
      ),
    ],
    'db-005': [
      // Pedro Pinto
      ProductBeneficiary(
        id: 'pb-014',
        idBenefit: 'benefit-010',
        state: 'No Entregado',
        idDeliveryBeneficiary: 'db-005',
      ),
      ProductBeneficiary(
        id: 'pb-015',
        idBenefit: 'benefit-011',
        state: 'No Entregado',
        idDeliveryBeneficiary: 'db-005',
      ),
      ProductBeneficiary(
        id: 'pb-016',
        idBenefit: 'benefit-012',
        state: 'No Entregado',
        idDeliveryBeneficiary: 'db-005',
      ),
    ],
  };

  return productsByDelivery[deliveryBeneficiaryId] ?? [];
}

// Provider para búsqueda de productos por beneficio
final productsByBenefitProvider =
    FutureProvider.family<List<ProductBeneficiary>, String>((
      ref,
      benefitId,
    ) async {
      await Future.delayed(const Duration(milliseconds: 300));

      // Buscar en todos los productos mock
      List<ProductBeneficiary> allProducts = [];
      final deliveryIds = ['db-001', 'db-002', 'db-003', 'db-004', 'db-005'];

      for (String deliveryId in deliveryIds) {
        allProducts.addAll(_getMockProductBeneficiaries(deliveryId));
      }

      return allProducts
          .where((product) => product.idBenefit == benefitId)
          .toList();
    });

// Provider para estadísticas globales de productos
final globalProductStatsProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  await Future.delayed(const Duration(milliseconds: 400));

  List<ProductBeneficiary> allProducts = [];
  final deliveryIds = ['db-001', 'db-002', 'db-003', 'db-004', 'db-005'];

  for (String deliveryId in deliveryIds) {
    allProducts.addAll(_getMockProductBeneficiaries(deliveryId));
  }

  final total = allProducts.length;
  final entregados = allProducts.where((p) => p.isEntregado).length;
  final noEntregados = allProducts.where((p) => p.isNoEntregado).length;

  return {
    'total': total,
    'entregados': entregados,
    'no_entregados': noEntregados,
    'porcentaje_entrega': total > 0 ? (entregados / total * 100).round() : 0,
    'productos_por_estado': {
      'Entregado': entregados,
      'No Entregado': noEntregados,
    },
  };
});
