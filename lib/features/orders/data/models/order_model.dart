// lib/features/orders/data/models/order_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_state.dart';

class OrderModel extends OrderEntity {
  OrderModel({
    required super.id,
    required super.tutor,
    required super.orderMonth,
    required super.programGroup,
    required super.beneficiaryCount,
    required super.nonBeneficiaryCount,
    required super.itemQuantities,
    required super.observations,
    required super.state,
    required super.registrationDate,
    required super.total,
    required super.lastModifiedDate,
    required super.placeId,
    super.blockDate,
    super.deleteDate,
    super.restoreDate,
  });

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      tutor: entity.tutor,
      orderMonth: entity.orderMonth,
      programGroup: entity.programGroup,
      beneficiaryCount: entity.beneficiaryCount,
      nonBeneficiaryCount: entity.nonBeneficiaryCount,
      itemQuantities: entity.itemQuantities,
      observations: entity.observations,
      state: entity.state,
      registrationDate: entity.registrationDate,
      total: entity.total,
      lastModifiedDate: entity.lastModifiedDate,
      placeId: entity.placeId,
      blockDate: entity.blockDate,
      deleteDate: entity.deleteDate,
      restoreDate: entity.restoreDate,
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
      tutor: data['tutor'] ?? '',
      orderMonth: data['order_month'] ?? '',
      programGroup: data['program_group'] ?? '',
      beneficiaryCount: (data['beneficiary_count'] as num).toInt(),
      nonBeneficiaryCount: (data['non_beneficiary_count'] as num).toInt(),
      itemQuantities: Map<String, int>.from(data['item_quantities'] ?? {}),
      observations: data['observations'] ?? '',
      state: OrderState.fromInt(data['state'] ?? 0),
      registrationDate: (data['registration_date'] as Timestamp).toDate(),
      total: (data['total'] as num).toDouble(),
      lastModifiedDate: (data['last_modified_date'] as Timestamp).toDate(),
      placeId: data['place_id'] ?? '',
      blockDate: _getTimestampOrNull(data['block_date']),
      deleteDate: _getTimestampOrNull(data['delete_date']),
      restoreDate: _getTimestampOrNull(data['restore_date']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tutor': tutor,
      'order_month': orderMonth,
      'program_group': programGroup,
      'beneficiary_count': beneficiaryCount,
      'non_beneficiary_count': nonBeneficiaryCount,
      'item_quantities': itemQuantities,
      'observations': observations,
      'state': state.value,
      'registration_date': Timestamp.fromDate(registrationDate),
      'total': total,
      'last_modified_date': Timestamp.fromDate(lastModifiedDate),
      if (blockDate != null) 'block_date': Timestamp.fromDate(blockDate!),
      if (deleteDate != null) 'delete_date': Timestamp.fromDate(deleteDate!),
      if (restoreDate != null) 'restore_date': Timestamp.fromDate(restoreDate!),
    };
  }
}