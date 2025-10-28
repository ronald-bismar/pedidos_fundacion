// lib/features/orders/domain/usecases/get_orders_usecase.dart
import '../repositories/order_repository.dart';
import '../entities/order_entity.dart';
class GetOrdersUseCase {
  final OrderRepository repository;
  GetOrdersUseCase(this.repository);
  Stream<List<OrderEntity>> call() => repository.getOrders();
}

