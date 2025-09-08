// lib/features/orders/presentation/providers/order_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart'; // Asegúrate de que esta línea NO esté comentada
import '../../data/datasources/order_remote_datasource.dart';
import '../../data/repositories_impl/order_repository_impl.dart';
import '../../domain/usecases/add_order_usecase.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/delete_order_usecase.dart';
import '../../domain/usecases/update_order_usecase.dart';
import '../../domain/usecases/restore_order_usecase.dart';
import '../../domain/usecases/block_order_usecase.dart';

// -----------------------------------------------------------
// Providers de la capa de datos
// -----------------------------------------------------------

final orderRemoteDataSourceProvider = Provider((ref) => OrderRemoteDataSource());

// -----------------------------------------------------------
// Provider del Repositorio
// -----------------------------------------------------------

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final remoteDataSource = ref.read(orderRemoteDataSourceProvider);
  return OrderRepositoryImpl(remoteDataSource: remoteDataSource);
});
// -----------------------------------------------------------
// Providers de los Casos de Uso
// -----------------------------------------------------------

final getOrdersUseCaseProvider = Provider((ref) {
  final repo = ref.read(orderRepositoryProvider);
  return GetOrdersUseCase(repo);
});

final addOrderUseCaseProvider = Provider((ref) {
  final repo = ref.read(orderRepositoryProvider);
  return AddOrderUseCase(repo);
});

final updateOrderUseCaseProvider = Provider((ref) {
  final repo = ref.read(orderRepositoryProvider);
  return UpdateOrderUseCase(repo);
});

final deleteOrderUseCaseProvider = Provider((ref) {
  final repo = ref.read(orderRepositoryProvider);
  return DeleteOrderUseCase(repo);
});

final restoreOrderUseCaseProvider = Provider((ref) {
  final repo = ref.read(orderRepositoryProvider);
  return RestoreOrderUseCase(repo);
});

final blockOrderUseCaseProvider = Provider((ref) {
  final repo = ref.read(orderRepositoryProvider);
  return BlockOrderUseCase(repo);
});

// -----------------------------------------------------------
// Provider del Notifier (La capa de Presentación)
// -----------------------------------------------------------

class OrdersNotifier extends AsyncNotifier<List<OrderEntity>> {
  @override
  Future<List<OrderEntity>> build() async {
    final getOrdersUseCase = ref.read(getOrdersUseCaseProvider);
    return await getOrdersUseCase.call();
  }

  Future<void> addOrder({
    required String tutor,
    required String orderMonth,
    required String programGroup,
    required Map<String, int> itemQuantities,
    required int beneficiaryCount,
    required int nonBeneficiaryCount,
    required String observations,
    required double total,
  }) async {
    state = const AsyncValue.loading();
    try {
      final newOrder = OrderEntity.newOrder(
        tutor: tutor,
        orderMonth: orderMonth,
        programGroup: programGroup,
        itemQuantities: itemQuantities,
        beneficiaryCount: beneficiaryCount,
        nonBeneficiaryCount: nonBeneficiaryCount,
        observations: observations,
        total: total,
      );
      final addOrderUseCase = ref.read(addOrderUseCaseProvider);
      await addOrderUseCase.call(newOrder);
      ref.invalidateSelf();
    } catch (e, stack) {
      state = AsyncValue.error('Error al agregar el pedido', stack);
    }
  }

  Future<void> updateOrder(OrderEntity updatedOrder) async {
    state = const AsyncValue.loading();
    try {
      final updateOrderUseCase = ref.read(updateOrderUseCaseProvider);
      await updateOrderUseCase.call(updatedOrder);
      ref.invalidateSelf();
    } catch (e, stack) {
      state = AsyncValue.error('Error al actualizar el pedido', stack);
    }
  }

  Future<void> deleteOrder(String orderId) async {
    state = const AsyncValue.loading();
    try {
      final deleteOrderUseCase = ref.read(deleteOrderUseCaseProvider);
      await deleteOrderUseCase.call(orderId);
      ref.invalidateSelf();
    } catch (e, stack) {
      state = AsyncValue.error('Error al eliminar el pedido', stack);
    }
  }

  Future<void> restoreOrder(String orderId) async {
    state = const AsyncValue.loading();
    try {
      final restoreOrderUseCase = ref.read(restoreOrderUseCaseProvider);
      await restoreOrderUseCase.call(orderId);
      ref.invalidateSelf();
    } catch (e, stack) {
      state = AsyncValue.error('Error al restaurar el pedido', stack);
    }
  }

  Future<void> blockOrder(String orderId) async {
    state = const AsyncValue.loading();
    try {
      final blockOrderUseCase = ref.read(blockOrderUseCaseProvider);
      await blockOrderUseCase.call(orderId);
      ref.invalidateSelf();
    } catch (e, stack) {
      state = AsyncValue.error('Error al bloquear el pedido', stack);
    }
  }
}

final ordersNotifierProvider = AsyncNotifierProvider<OrdersNotifier, List<OrderEntity>>(() {
  return OrdersNotifier();
});