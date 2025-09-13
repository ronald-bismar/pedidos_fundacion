// lib/features/orders/data/models/order_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_state.dart';

class OrderModel extends OrderEntity {
  OrderModel({
    required super.id,
    required super.nameuser,
    required super.nameTutor,
    required super.nameGroup,
    required super.namePlace,
    required super.nameOrder,
    required super.dateOrderMonth,
    required super.beneficiaryCount,
    required super.nonBeneficiaryCount,
    required super.observedBeneficiaryCount,
    required super.totalOrder,
    required super.itemQuantities,
    required super.observations,
    required super.state,
    required super.placeId,
    required super.groupId,
    required super.registrationDate,
    required super.lastModifiedDate,
    super.lastblockDate,
    super.lastdeleteDate,
    super.lastrestoreDate,
  });

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      nameuser: entity.nameuser,
      nameTutor: entity.nameTutor,
      nameGroup: entity.nameGroup,
      namePlace: entity.namePlace,
      nameOrder: entity.nameOrder,
      dateOrderMonth: entity.dateOrderMonth,
      beneficiaryCount: entity.beneficiaryCount,
      nonBeneficiaryCount: entity.nonBeneficiaryCount,
      observedBeneficiaryCount: entity.observedBeneficiaryCount,
      totalOrder: entity.totalOrder,
      itemQuantities: entity.itemQuantities,
      observations: entity.observations,
      state: entity.state,
      placeId: entity.placeId,
      groupId: entity.groupId,
      registrationDate: entity.registrationDate,
      lastModifiedDate: entity.lastModifiedDate,
      lastblockDate: entity.lastblockDate,
      lastdeleteDate: entity.lastdeleteDate,
      lastrestoreDate: entity.lastrestoreDate,
    );
  }

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    DateTime? _getTimestampOrNull(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      return null;
    }

    return OrderModel(
      id: doc.id,
      nameuser: data['name_user'] ?? '',
      nameTutor: data['name_tutor'] ?? '',
      nameGroup: data['name_group'] ?? '',
      namePlace: data['name_place'] ?? '',
      nameOrder: data['name_order'] ?? '',
      dateOrderMonth: data['date_order_month'] ?? '',
      // ✅ Solución: Usa `as num?` para permitir valores nulos y `?? 0` para un valor por defecto.
      beneficiaryCount: (data['beneficiary_count'] as num?)?.toInt() ?? 0,
      nonBeneficiaryCount: (data['non_beneficiary_count'] as num?)?.toInt() ?? 0,
      observedBeneficiaryCount: (data['observed_beneficiary_count'] as num?)?.toInt() ?? 0,
      totalOrder: (data['total_order'] as num?)?.toDouble() ?? 0.0,
      itemQuantities: Map<String, int>.from(data['item_quantities'] ?? {}),
      observations: data['observations'] ?? '',
      state: OrderState.fromInt(data['state'] ?? 0),
      placeId: data['place_id'] ?? '',
      groupId: data['group_id'] ?? '',
      registrationDate: _getTimestampOrNull(data['registration_date']) ?? DateTime.now(),
      lastModifiedDate: _getTimestampOrNull(data['last_modified_date']) ?? DateTime.now(),
      lastblockDate: _getTimestampOrNull(data['last_block_date']),
      lastdeleteDate: _getTimestampOrNull(data['last_delete_date']),
      lastrestoreDate: _getTimestampOrNull(data['last_restore_date']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name_user': nameuser,
      'name_tutor': nameTutor,
      'name_group': nameGroup,
      'name_place': namePlace,
      'name_order': nameOrder,
      'date_order_month': dateOrderMonth,
      'beneficiary_count': beneficiaryCount,
      'non_beneficiary_count': nonBeneficiaryCount,
      'observed_beneficiary_count': observedBeneficiaryCount,
      'total_order': totalOrder,
      'item_quantities': itemQuantities,
      'observations': observations,
      'state': state.value,
      'place_id': placeId,
      'group_id': groupId,
      'registration_date': Timestamp.fromDate(registrationDate),
      'last_modified_date': Timestamp.fromDate(lastModifiedDate),
      if (lastblockDate != null) 'last_block_date': Timestamp.fromDate(lastblockDate!),
      if (lastdeleteDate != null) 'last_delete_date': Timestamp.fromDate(lastdeleteDate!),
      if (lastrestoreDate != null) 'last_restore_date': Timestamp.fromDate(lastrestoreDate!),
    };
  }
}