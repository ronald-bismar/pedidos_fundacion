// lib/features/orders/domain/entities/order_entity.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'order_state.dart';

const _uuid = Uuid();

class OrderEntity {
  final String id;
  final String tutor;
  final String orderMonth;
  final String programGroup;
  final int beneficiaryCount;
  final int nonBeneficiaryCount;
  final Map<String, int> itemQuantities;
  final String observations;
  final OrderState state;
  final DateTime registrationDate;
  final double total;
  final DateTime lastModifiedDate;
  final DateTime? blockDate;
  final DateTime? deleteDate;
  final DateTime? restoreDate;

  OrderEntity({
    required this.id,
    required this.tutor,
    required this.orderMonth,
    required this.programGroup,
    required this.beneficiaryCount,
    required this.nonBeneficiaryCount,
    required this.itemQuantities,
    required this.observations,
    required this.state,
    required this.registrationDate,
    required this.total,
    required this.lastModifiedDate,
    this.blockDate,
    this.deleteDate,
    this.restoreDate,
  });

  factory OrderEntity.newOrder({
    required String tutor,
    required String orderMonth,
    required String programGroup,
    required Map<String, int> itemQuantities,
    required int beneficiaryCount,
    required int nonBeneficiaryCount,
    required String observations,
    required double total,
  }) {
    return OrderEntity(
      id: _uuid.v4(),
      tutor: tutor,
      orderMonth: orderMonth,
      programGroup: programGroup,
      beneficiaryCount: beneficiaryCount,
      nonBeneficiaryCount: nonBeneficiaryCount,
      itemQuantities: itemQuantities,
      observations: observations,
      state: OrderState.active,
      registrationDate: DateTime.now(),
      total: total,
      lastModifiedDate: DateTime.now(),
    );
  }

  factory OrderEntity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    DateTime? _getTimestampOrString(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) {
        return value.toDate();
      } else if (value is String) {
        return DateTime.parse(value);
      }
      return null;
    }
    return OrderEntity(
      id: doc.id,
      tutor: data['tutor'] ?? '',
      orderMonth: data['order_month'] ?? '',
      programGroup: data['program_group'] ?? '',
      beneficiaryCount: (data['beneficiary_count'] as num).toInt(),
      nonBeneficiaryCount: (data['non_beneficiary_count'] as num).toInt(),
      itemQuantities: Map<String, int>.from(data['item_quantities'] ?? {}),
      observations: data['observations'] ?? '',
      state: OrderState.fromInt(data['state'] ?? 0),
      registrationDate: _getTimestampOrString(data['registration_date'])!,
      total: (data['total'] as num).toDouble(),
      lastModifiedDate: _getTimestampOrString(data['last_modified_date'])!,
      blockDate: _getTimestampOrString(data['block_date']),
      deleteDate: _getTimestampOrString(data['delete_date']),
      restoreDate: _getTimestampOrString(data['restore_date']),
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