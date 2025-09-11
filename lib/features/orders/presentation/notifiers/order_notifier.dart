// lib/features/orders/presentation/notifiers/order_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/add_order_usecase.dart';
import 'order_state.dart';

class OrderNotifier extends StateNotifier<OrderState> {
  final AddOrderUseCase _addUseCase;

  OrderNotifier({required AddOrderUseCase addUseCase})
      : _addUseCase = addUseCase,
        super(OrderState());

  Future<void> addOrder(OrderEntity newOrder) async {
    state = OrderState(isLoading: true);
    try {
      await _addUseCase.call(newOrder);
      state = OrderState(isSuccess: true);
    } catch (e) {
      state = OrderState(errorMessage: 'Error al registrar pedido: $e');
    }
  }
}