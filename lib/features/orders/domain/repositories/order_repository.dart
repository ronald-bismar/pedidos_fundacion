// lib/features/orders/domain/repositories/order_repository.dart

import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<void> addOrder(OrderEntity order);
  Stream<List<OrderEntity>> getOrders();
  Future<void> updateOrder(OrderEntity order);
  Future<void> deleteOrder(String id);
  Future<void> restoreOrder(String id);
  Future<void> blockOrder(String id);
  

}

