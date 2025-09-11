// lib/features/orders/data/datasources/order_remote_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../../domain/entities/order_state.dart';

class OrderRemoteDataSource {
  final _ordersCollection = FirebaseFirestore.instance.collection('orders');

  Future<void> addOrder(OrderModel order) async {
    await _ordersCollection.doc(order.id).set(order.toFirestore());
  }

  Future<void> updateOrder(OrderModel order) async {
    await _ordersCollection.doc(order.id).update(order.toFirestore());
  }

  Future<void> deleteOrder(String id) async {
    await _ordersCollection.doc(id).update({
      'state': OrderState.deleted.value,
      'last_delete_date': FieldValue.serverTimestamp(),
      'last_modified_date': FieldValue.serverTimestamp(),
    });
  }

  Future<void> blockOrder(String id) async {
    await _ordersCollection.doc(id).update({
      'state': OrderState.blocked.value,
      'last_block_date': FieldValue.serverTimestamp(),
      'last_modified_date': FieldValue.serverTimestamp(),
    });
  }

  Future<void> restoreOrder(String id) async {
    await _ordersCollection.doc(id).update({
      'state': OrderState.active.value,
      'last_delete_date': FieldValue.delete(),
      'last_restore_date': FieldValue.serverTimestamp(),
      'last_modified_date': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<OrderModel>> getOrders() {
    return _ordersCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();
    });
  }

  Future<bool> hasOrderForGroupAndMonth({
    required String groupId,
    required String month,
  }) async {
    final querySnapshot = await _ordersCollection
        .where('groupId', isEqualTo: groupId)
        .where('orderMonth', isEqualTo: month)
        .where('state', isNotEqualTo: OrderState.deleted.value)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }
}