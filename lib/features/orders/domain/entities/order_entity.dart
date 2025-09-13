// lib/features/orders/domain/entities/order_entity.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_state.dart';

class OrderEntity {
  final String id;
  final String nameuser;
  final String nameTutor;
  final String nameGroup;
  final String namePlace;
  final String nameOrder;
  final String dateOrderMonth;
  final int beneficiaryCount;
  final int nonBeneficiaryCount;
  final int observedBeneficiaryCount;
  final double? totalOrder;
  final Map<String, int> itemQuantities;
  final String observations;
  final OrderState state;
  final String placeId;
  final String groupId;
  final DateTime registrationDate;
  final DateTime lastModifiedDate;
  final DateTime? lastblockDate;
  final DateTime? lastdeleteDate;
  final DateTime? lastrestoreDate;

  OrderEntity({
    required this.id,
    required this.nameuser,
    required this.nameTutor,
    required this.nameGroup,
    required this.namePlace,
    required this.nameOrder,
    required this.dateOrderMonth,
    required this.beneficiaryCount,
    required this.nonBeneficiaryCount,
    required this.observedBeneficiaryCount,
    required this.totalOrder,
    required this.itemQuantities,
    required this.observations,
    required this.state,
    required this.placeId,
    required this.groupId,
    required this.registrationDate,
    required this.lastModifiedDate,
    this.lastblockDate,
    this.lastdeleteDate,
    this.lastrestoreDate,
  });

  factory OrderEntity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    DateTime? _getTimestampOrNull(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      return null;
    }

    // 💡 Corrección aquí: Usar un casteo a tipo nullable `as num?`
    final totalOrderValue = data['total_order'] as num?;

    return OrderEntity(
      id: doc.id,
      nameuser: data['name_user'] ?? '',
      nameTutor: data['name_tutor'] ?? '',
      nameGroup: data['name_group'] ?? '',
      namePlace: data['name_place'] ?? '',
      nameOrder: data['name_order'] ?? '',
      dateOrderMonth: data['date_order_month'] ?? '',
      beneficiaryCount: (data['beneficiary_count'] as num).toInt(),
      nonBeneficiaryCount: (data['non_beneficiary_count'] as num).toInt(),
      observedBeneficiaryCount: (data['observed_beneficiary_count'] as num).toInt(),
      // ✅ Solución: Si el valor es nulo, `totalOrderValue` será nulo. Si no, se convierte a `double`.
      totalOrder: totalOrderValue?.toDouble() ?? 0.0,
      itemQuantities: Map<String, int>.from(data['item_quantities'] ?? {}),
      observations: data['observations'] ?? '',
      state: OrderState.fromInt(data['state'] ?? 0),
      placeId: data['place_id'] ?? '',
      groupId: data['group_id'] ?? '',
      registrationDate: (data['registration_date'] as Timestamp).toDate(),
      lastModifiedDate: (data['last_modified_date'] as Timestamp).toDate(),
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