// lib/features/orders/presentation/notifiers/orders_list_notifier.dart

import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/update_order_usecase.dart';
import '../../domain/usecases/delete_order_usecase.dart';
import '../../domain/usecases/restore_order_usecase.dart';
import '../../domain/usecases/block_order_usecase.dart';
import '../providers/order_providers.dart';
import '../../domain/entities/order_state.dart'; 

class OrdersListNotifier extends AsyncNotifier<List<OrderEntity>> {
  @override
  Future<List<OrderEntity>> build() async {
    log('Iniciando carga de pedidos...');
    final getOrdersUseCase = ref.read(getOrdersUseCaseProvider);
    return await getOrdersUseCase.call();
  }

  Future<void> addOrder({
    required String tutor,
    required String orderMonth,
    required String programGroup,
    required int beneficiaryCount,
    required int nonBeneficiaryCount,
    required String observations,
    required String placeId,
    required int itemQuantity,
    required double total,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final addOrderUseCase = ref.read(addOrderUseCaseProvider);
      final getOrdersUseCase = ref.read(getOrdersUseCaseProvider);

      final now = DateTime.now(); 

      final newOrder = OrderEntity(
        id: '', 
        tutor: tutor,
        orderMonth: orderMonth,
        programGroup: programGroup,
        beneficiaryCount: beneficiaryCount,
        nonBeneficiaryCount: nonBeneficiaryCount,
        observations: observations,
        itemQuantities: {placeId: itemQuantity},
        total: total,
        placeId: placeId,
        state: OrderState.active,
        registrationDate: now,
        lastModifiedDate: now, 
 
      );

      await addOrderUseCase.call(newOrder);

      return await getOrdersUseCase.call();
    });
  }

  Future<void> updateOrder(OrderEntity updatedOrder) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updateOrderUseCase = ref.read(updateOrderUseCaseProvider);
      final getOrdersUseCase = ref.read(getOrdersUseCaseProvider);
      await updateOrderUseCase.call(updatedOrder);
      return await getOrdersUseCase.call();
    });
  }

  Future<void> deleteOrder(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final deleteOrderUseCase = ref.read(deleteOrderUseCaseProvider);
      final getOrdersUseCase = ref.read(getOrdersUseCaseProvider);
      await deleteOrderUseCase.call(id);
      return await getOrdersUseCase.call();
    });
  }

  Future<void> restoreOrder(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final restoreOrderUseCase = ref.read(restoreOrderUseCaseProvider);
      final getOrdersUseCase = ref.read(getOrdersUseCaseProvider);
      await restoreOrderUseCase.call(id);
      return await getOrdersUseCase.call();
    });
  }

  Future<void> blockOrder(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final blockOrderUseCase = ref.read(blockOrderUseCaseProvider);
      final getOrdersUseCase = ref.read(getOrdersUseCaseProvider);
      await blockOrderUseCase.call(id);
      return await getOrdersUseCase.call();
    });
  }
}