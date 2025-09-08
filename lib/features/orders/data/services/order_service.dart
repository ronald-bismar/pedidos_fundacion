// lib/features/orders/data/services/order_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/order_entity.dart';
import '../models/order_model.dart';
import '../../domain/entities/order_state.dart';

class OrderService {
  final _db = FirebaseFirestore.instance;

  Future<void> addOrder(OrderEntity order) async {
    final CollectionReference ordersCollection = _db.collection('orders');
    final placeId = order.placeId;
    final groupId = order.programGroup;

    final lastOrderDoc = await ordersCollection
        .orderBy('id', descending: true)
        .limit(1)
        .get();

    String newId = 'PGL_000001';
    if (lastOrderDoc.docs.isNotEmpty) {
      final lastId = lastOrderDoc.docs.first.id;
      final number = int.parse(lastId.split('_')[1]) + 1;
      newId = 'PGL_${NumberFormat('000000').format(number)}';
    }

    final newOrder = OrderModel(
      id: newId,
      tutor: order.tutor,
      orderMonth: order.orderMonth,
      programGroup: order.programGroup,
      beneficiaryCount: order.beneficiaryCount,
      nonBeneficiaryCount: order.nonBeneficiaryCount,
      observations: order.observations,
      placeId: order.placeId,
      total: order.total,
      itemQuantities: order.itemQuantities,
      state: OrderState.active, 
      registrationDate: DateTime.now(),
      lastModifiedDate: DateTime.now(),
      blockDate: null,
      deleteDate: null,
      restoreDate: null,
    );

    await ordersCollection.doc(newOrder.id).set(newOrder.toFirestore());

    final groupRef = _db
        .collection('places')
        .doc(placeId)
        .collection('groups')
        .doc(groupId);
    final groupOrdersCollection = groupRef.collection('orders');
    await groupOrdersCollection.doc(newOrder.id).set(newOrder.toFirestore());
  }

  Future<void> editOrder(OrderModel order) async {
    final docRef = _db.collection('orders').doc(order.id);
    await docRef.update({
      'tutor': order.tutor,
      'beneficiary_count': order.beneficiaryCount,
      'non_beneficiary_count': order.nonBeneficiaryCount,
      'observations': order.observations,
      'total': order.total,
      'item_quantities': order.itemQuantities,
      'state': order.state.value,
      'last_modified_date': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteOrder(String orderId) async {
    final docRef = _db.collection('orders').doc(orderId);
    await docRef.update({
      'delete_date': FieldValue.serverTimestamp(),
      'state': OrderState.deleted.value,
      'last_modified_date': FieldValue.serverTimestamp(),
    });
  }

  Future<void> restoreOrder(String orderId) async {
    final docRef = _db.collection('orders').doc(orderId);
    await docRef.update({
      'restore_date': FieldValue.serverTimestamp(),
      'state': OrderState.active.value,
      'last_modified_date': FieldValue.serverTimestamp(),
    });
  }

  Future<void> blockOrder(String orderId) async {
    final docRef = _db.collection('orders').doc(orderId);
    await docRef.update({
      'block_date': FieldValue.serverTimestamp(),
      'state': OrderState.blocked.value,
      'last_modified_date': FieldValue.serverTimestamp(),
    });
  }
}