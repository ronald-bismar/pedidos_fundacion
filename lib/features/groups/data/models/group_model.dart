// lib/features/groups/data/models/group_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/entities/group_state.dart';

class GroupModel extends GroupEntity {
  GroupModel({
    required super.id,
    required super.name,
    required super.idTutor,
    required super.minAge,
    required super.maxAge,
    required super.state,
    required super.registrationDate,
    required super.lastModifiedDate,
    required super.placeIds,
    super.blockDate,
    super.deleteDate,
    super.restoreDate,
  });

  factory GroupModel.fromEntity(GroupEntity entity) {
    return GroupModel(
      id: entity.id,
      name: entity.name,
      idTutor: entity.idTutor,
      minAge: entity.minAge,
      maxAge: entity.maxAge,
      state: entity.state,
      registrationDate: entity.registrationDate,
      lastModifiedDate: entity.lastModifiedDate,
      placeIds: entity.placeIds,
      blockDate: entity.blockDate,
      deleteDate: entity.deleteDate,
      restoreDate: entity.restoreDate,
    );
  }

  factory GroupModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw StateError('Document data is null for id: ${doc.id}');
    }

    DateTime? _parseDate(dynamic value) {
      if (value is String) {
        return DateTime.tryParse(value);
      } else if (value is Timestamp) {
        return value.toDate();
      }
      return null;
    }

    final int stateValue = (data['state'] as int?) ?? GroupState.active.value;
    final DateTime firestoreUpdatedAt = _parseDate(data['updatedAt']) ?? DateTime.now();

    return GroupModel(
      id: doc.id,
      name: data['groupName'] as String? ?? '',
      idTutor: data['idTutor'] as String? ?? '',
      minAge: (data['minAge'] as num?)?.toInt() ?? 0,
      maxAge: (data['maxAge'] as num?)?.toInt() ?? 0,
      state: GroupState.fromInt(stateValue),
      registrationDate: firestoreUpdatedAt,
      lastModifiedDate: firestoreUpdatedAt,
      placeIds: List<String>.from(data['placeIds'] ?? []),
      blockDate: null,
      deleteDate: null,
      restoreDate: null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'groupName': name,
      'idTutor': idTutor,
      'minAge': minAge,
      'maxAge': maxAge,
      'state': state.value,
      'updatedAt': Timestamp.fromDate(lastModifiedDate),
      'placeIds': placeIds,
      if (blockDate != null) 'block_date': Timestamp.fromDate(blockDate!),
      if (deleteDate != null) 'delete_date': Timestamp.fromDate(deleteDate!),
      if (restoreDate != null) 'restore_date': Timestamp.fromDate(restoreDate!),
    };
  }
}