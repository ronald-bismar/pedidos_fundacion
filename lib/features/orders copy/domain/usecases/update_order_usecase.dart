// lib/features/orders/domain/usecases/update_order_usecase.dart

import '../repositories/order_repository.dart';
import '../entities/order_entity.dart';

class UpdateOrderUseCase {
  final OrderRepository repository;

  UpdateOrderUseCase(this.repository);

  Future<void> call(OrderEntity updatedOrder) async {
    await repository.updateOrder(updatedOrder);
  }
}