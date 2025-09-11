// lib/features/groups/domain/entities/group_entity.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'group_state.dart';


const _uuid = Uuid();

class GroupEntity {
  final String id;
  final String name;
  final String idTutor;
  final List<String> placeIds; 
  final int minAge;
  final int maxAge;
  final GroupState state;
  final DateTime registrationDate;
  final DateTime lastModifiedDate;
  final DateTime? blockDate;
  final DateTime? deleteDate;
  final DateTime? restoreDate;

  GroupEntity({
    required this.id,
    required this.name,
    required this.idTutor,
    required this.placeIds, 
    required this.minAge,
    required this.maxAge,
    required this.state,
    required this.registrationDate,
    required this.lastModifiedDate,
    this.blockDate,
    this.deleteDate,
    this.restoreDate,
  });

  factory GroupEntity.newGroup({
    required String name,
    required String idTutor,
    required List<String> placeIds, 
    required int minAge,
    required int maxAge,
  }) {
    return GroupEntity(
      id: _uuid.v4(),
      name: name,
      idTutor: idTutor,
      placeIds: placeIds, 
      minAge: minAge,
      maxAge: maxAge,
      state: GroupState.active,
      registrationDate: DateTime.now(),
      lastModifiedDate: DateTime.now(),
    );
  }

  factory GroupEntity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    DateTime? _getTimestampOrNull(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      return null;
    }

    return GroupEntity(
      id: doc.id,
      name: data['name'] ?? '',
      idTutor: data['id_tutor'] ?? '',
      placeIds: List<String>.from(data['placeIds'] ?? []), 
      minAge: (data['min_age'] as num).toInt(),
      maxAge: (data['max_age'] as num).toInt(),
      state: GroupState.fromInt(data['state'] ?? 1),
      registrationDate: _getTimestampOrNull(data['registration_date'])!,
      lastModifiedDate: _getTimestampOrNull(data['last_modified_date'])!,
      blockDate: _getTimestampOrNull(data['block_date']),
      deleteDate: _getTimestampOrNull(data['delete_date']),
      restoreDate: _getTimestampOrNull(data['restore_date']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'id_tutor': idTutor,
      'placeIds': placeIds, 
      'min_age': minAge,
      'max_age': maxAge,
      'state': state.value,
      'registration_date': Timestamp.fromDate(registrationDate),
      'last_modified_date': Timestamp.fromDate(lastModifiedDate),
      if (blockDate != null) 'block_date': Timestamp.fromDate(blockDate!),
      if (deleteDate != null) 'delete_date': Timestamp.fromDate(deleteDate!),
      if (restoreDate != null) 'restore_date': Timestamp.fromDate(restoreDate!),
    };
  }
}