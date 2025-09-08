// lib/features/orders/data/datasources/order_remote_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_state.dart';

class OrderRemoteDataSource {
  final _ordersCollection = FirebaseFirestore.instance.collection('orders');

  Future<void> addOrder(OrderEntity order) async {
    print('Guardando en Firebase: ${order.toFirestore()}');
    await _ordersCollection.doc(order.id).set(order.toFirestore());
    print('Guardado exitoso en Firebase: ${order.id}');
  }

  Future<void> updateOrder(OrderEntity order) async {
    await _ordersCollection.doc(order.id).update(order.toFirestore());
  }

  Future<void> deleteOrder(String id) async {
    await _ordersCollection.doc(id).update({
      'state': OrderState.deleted.value,
      'delete_date': Timestamp.fromDate(DateTime.now()),
      'last_modified_date': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> blockOrder(String id) async {
    await _ordersCollection.doc(id).update({
      'state': OrderState.blocked.value,
      'block_date': Timestamp.fromDate(DateTime.now()),
      'last_modified_date': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> restoreOrder(String id) async {
    await _ordersCollection.doc(id).update({
      'state': OrderState.active.value,
      'delete_date': null,
      'restore_date': Timestamp.fromDate(DateTime.now()),
      'last_modified_date': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<List<OrderEntity>> getOrders() async {
    final snapshot = await _ordersCollection.get();
    return snapshot.docs.map((doc) => OrderEntity.fromFirestore(doc)).toList();
  }

  // Nuevo: Método para verificar si ya existe un pedido para un grupo y mes
  Future<bool> hasOrderForGroupAndMonth({
    required String groupId,
    required String month,
  }) async {
    final querySnapshot = await _ordersCollection
        .where('programGroup', isEqualTo: groupId)
        .where('orderMonth', isEqualTo: month)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }
}
