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
    final groupId = order.groupId;

    final lastOrderDoc = await ordersCollection
        .orderBy('registration_date', descending: true)
        .limit(1)
        .get();

    String newId = 'PGL_000001';
    if (lastOrderDoc.docs.isNotEmpty) {
      final lastDoc = lastOrderDoc.docs.first;
      final lastId = lastDoc.id;
      final number = int.tryParse(lastId.split('_').last) ?? 0;
      newId = 'PGL_${NumberFormat('000000').format(number + 1)}';
    }

    final newOrder = OrderModel(
      id: newId,
      nameuser: order.nameuser,
      nameTutor: order.nameTutor,
      nameGroup: order.nameGroup,
      namePlace: order.namePlace,
      nameOrder: order.nameOrder,
      dateOrderMonth: order.dateOrderMonth,
      beneficiaryCount: order.beneficiaryCount,
      nonBeneficiaryCount: order.nonBeneficiaryCount,
      observedBeneficiaryCount: order.observedBeneficiaryCount,
      totalOrder: order.totalOrder,
      itemQuantities: order.itemQuantities,
      observations: order.observations,
      state: OrderState.active,
      placeId: order.placeId,
      groupId: order.groupId,
      registrationDate: DateTime.now(),
      lastModifiedDate: DateTime.now(),
      lastblockDate: null,
      lastdeleteDate: null,
      lastrestoreDate: null,
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
      'name_tutor': order.nameTutor,
      'name_group': order.nameGroup,
      'name_place': order.namePlace,
      'name_order': order.nameOrder,
      'date_order_month': order.dateOrderMonth,
      'beneficiary_count': order.beneficiaryCount,
      'non_beneficiary_count': order.nonBeneficiaryCount,
      'observed_beneficiary_count': order.observedBeneficiaryCount,
      'total_order': order.totalOrder,
      'item_quantities': order.itemQuantities,
      'observations': order.observations,
      'state': order.state.value,
      'last_modified_date': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteOrder(String orderId) async {
    final docRef = _db.collection('orders').doc(orderId);
    await docRef.update({
      'last_delete_date': FieldValue.serverTimestamp(),
      'state': OrderState.deleted.value,
      'last_modified_date': FieldValue.serverTimestamp(),
    });
  }

  Future<void> restoreOrder(String orderId) async {
    final docRef = _db.collection('orders').doc(orderId);
    await docRef.update({
      'last_restore_date': FieldValue.serverTimestamp(),
      'state': OrderState.active.value,
      'last_modified_date': FieldValue.serverTimestamp(),
    });
  }

  Future<void> blockOrder(String orderId) async {
    final docRef = _db.collection('orders').doc(orderId);
    await docRef.update({
      'last_block_date': FieldValue.serverTimestamp(),
      'state': OrderState.blocked.value,
      'last_modified_date': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<OrderModel>> getOrders() {
    return _db.collection('orders').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
    });
  }
}