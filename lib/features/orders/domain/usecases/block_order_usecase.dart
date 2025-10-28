// lib/features/orders/domain/usecases/block_order_usecase.dart

import '../repositories/order_repository.dart';

class BlockOrderUseCase {
  final OrderRepository repository;

  BlockOrderUseCase(this.repository);

  Future<void> call(String orderId) async {
    await repository.blockOrder(orderId);
  }
}