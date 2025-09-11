// lib/features/orders/presentation/notifiers/orders_list_notifier.dart

import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/update_order_usecase.dart';
import '../../domain/usecases/delete_order_usecase.dart';
import '../../domain/usecases/restore_order_usecase.dart';
import '../../domain/usecases/block_order_usecase.dart';
import '../../domain/usecases/add_order_usecase.dart';
import '../providers/order_providers.dart';
import '../../domain/entities/order_state.dart';

class OrdersListNotifier extends StreamNotifier<List<OrderEntity>> {
  @override
  Stream<List<OrderEntity>> build() {
    log('Iniciando escucha de pedidos en tiempo real...');
    final getOrdersUseCase = ref.read(getOrdersUseCaseProvider);
    return getOrdersUseCase.call();
  }

  Future<void> addOrder({
    required String nameuser,
    required String nameTutor,
    required String nameGroup,
    required String namePlace,
    required String nameOrder,
    required String dateOrderMonth,
    required int beneficiaryCount,
    required int nonBeneficiaryCount,
    required int observedBeneficiaryCount,
    required double totalOrder,
    required Map<String, int> itemQuantities,
    required String observations,
    required String placeId,
    required String groupId,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final addOrderUseCase = ref.read(addOrderUseCaseProvider);
      final now = DateTime.now();

      final newOrder = OrderEntity(
        id: '',
        nameuser: nameuser,
        nameTutor: nameTutor,
        nameGroup: nameGroup,
        namePlace: namePlace,
        nameOrder: nameOrder,
        dateOrderMonth: dateOrderMonth,
        beneficiaryCount: beneficiaryCount,
        nonBeneficiaryCount: nonBeneficiaryCount,
        observedBeneficiaryCount: observedBeneficiaryCount,
        totalOrder: totalOrder,
        itemQuantities: itemQuantities,
        observations: observations,
        state: OrderState.active,
        placeId: placeId,
        groupId: groupId,
        registrationDate: now,
        lastModifiedDate: now,
      );

      await addOrderUseCase.call(newOrder);

      // No es necesario retornar nada, el Stream se actualizará automáticamente
      return state.value!;
    });
  }

  Future<void> updateOrder(OrderEntity updatedOrder) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updateOrderUseCase = ref.read(updateOrderUseCaseProvider);
      await updateOrderUseCase.call(updatedOrder);
      return state.value!;
    });
  }

  Future<void> deleteOrder(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final deleteOrderUseCase = ref.read(deleteOrderUseCaseProvider);
      await deleteOrderUseCase.call(id);
      return state.value!;
    });
  }

  Future<void> restoreOrder(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final restoreOrderUseCase = ref.read(restoreOrderUseCaseProvider);
      await restoreOrderUseCase.call(id);
      return state.value!;
    });
  }

  Future<void> blockOrder(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final blockOrderUseCase = ref.read(blockOrderUseCaseProvider);
      await blockOrderUseCase.call(id);
      return state.value!;
    });
  }
}