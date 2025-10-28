// lib/features/orders/domain/usecases/add_order_usecase.dart
import '../repositories/order_repository.dart';
import '../entities/order_entity.dart';
class AddOrderUseCase {
  final OrderRepository repository;
  AddOrderUseCase(this.repository);
  Future<void> call(OrderEntity order) => repository.addOrder(order);
}