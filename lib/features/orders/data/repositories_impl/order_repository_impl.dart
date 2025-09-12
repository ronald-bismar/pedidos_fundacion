// lib/features/orders/data/repositories_impl/order_repository_impl.dart

import 'dart:developer';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addOrder(OrderEntity order) async {
    log('--> REPOSITORIO: Intentando agregar pedido a Firebase: ${order.id}');
    final orderModel = OrderModel.fromEntity(order);
    await remoteDataSource.addOrder(orderModel);
    log('--> REPOSITORIO: Pedido agregado exitosamente a Firebase.');
  }

  @override
  Future<void> updateOrder(OrderEntity order) async {
    log(
      '--> REPOSITORIO: Intentando actualizar pedido en Firebase: ${order.id}',
    );
    final orderModel = OrderModel.fromEntity(order);
    await remoteDataSource.updateOrder(orderModel);
    log('--> REPOSITORIO: Pedido actualizado exitosamente en Firebase.');
  }

  @override
  Future<void> deleteOrder(String id) async {
    log('--> REPOSITORIO: Intentando eliminar pedido en Firebase con ID: $id');
    await remoteDataSource.deleteOrder(id);
    log('--> REPOSITORIO: Pedido eliminado exitosamente de Firebase.');
  }

  @override
  Future<void> restoreOrder(String id) async {
    log('--> REPOSITORIO: Intentando restaurar pedido en Firebase con ID: $id');
    await remoteDataSource.restoreOrder(id);
    log('--> REPOSITORIO: Pedido restaurado exitosamente en Firebase.');
  }

  @override
  Future<void> blockOrder(String id) async {
    log('--> REPOSITORIO: Intentando bloquear pedido en Firebase con ID: $id');
    await remoteDataSource.blockOrder(id);
    log('--> REPOSITORIO: Pedido bloqueado exitosamente en Firebase.');
  }

  @override
  Stream<List<OrderEntity>> getOrders() {
    log('--> REPOSITORIO: Obteniendo stream de pedidos de Firebase.');
    return remoteDataSource.getOrders().map((models) {
      return models.map((model) => model as OrderEntity).toList();
    });
  }

  @override
  Future<bool> hasOrderForGroupAndMonth({
    required String groupId,
    required String month,
  }) {
    log(
      '--> REPOSITORIO: Verificando si ya existe un pedido para el grupo $groupId y mes $month.',
    );
    return remoteDataSource.hasOrderForGroupAndMonth(
      groupId: groupId,
      month: month,
    );
  }
}