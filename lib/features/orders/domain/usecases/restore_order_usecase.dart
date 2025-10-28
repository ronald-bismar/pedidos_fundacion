// lib/features/orders/domain/usecases/restore_order_usecase.dart

import '../repositories/order_repository.dart';

class RestoreOrderUseCase {
  final OrderRepository repository;

  RestoreOrderUseCase(this.repository);

  Future<void> call(String orderId) async {
    await repository.restoreOrder(orderId);
  }
}