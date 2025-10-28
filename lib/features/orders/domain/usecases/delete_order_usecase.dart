// lib/features/orders/domain/usecases/delete_order_usecase.dart

import '../repositories/order_repository.dart';

class DeleteOrderUseCase {
  final OrderRepository repository;

  DeleteOrderUseCase(this.repository);

  Future<void> call(String orderId) async {
    await repository.deleteOrder(orderId);
  }
}