// lib/features/groups/data/models/group_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/entities/group_state.dart';
import '../../../places/domain/entities/place_entity.dart'; 

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
    super.place, 
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
      place: entity.place, 
      blockDate: entity.blockDate,
      deleteDate: entity.deleteDate,
      restoreDate: entity.restoreDate,
    );
  }

  factory GroupModel.fromFirestore(DocumentSnapshot doc, PlaceEntity? place) { 
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
    final DateTime registrationDate = _parseDate(data['registration_date']) ?? DateTime.now();
    final DateTime lastModifiedDate = _parseDate(data['last_modified_date']) ?? DateTime.now();

    return GroupModel(
      id: doc.id,
      name: data['name'] as String? ?? '', 
      idTutor: data['id_tutor'] as String? ?? '', 
      minAge: (data['min_age'] as num?)?.toInt() ?? 0, 
      maxAge: (data['max_age'] as num?)?.toInt() ?? 0, 
      state: GroupState.fromInt(stateValue),
      registrationDate: registrationDate,
      lastModifiedDate: lastModifiedDate,
      place: place, 
      blockDate: _parseDate(data['block_date']),
      deleteDate: _parseDate(data['delete_date']),
      restoreDate: _parseDate(data['restore_date']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'id_tutor': idTutor,
      'placeId': place?.id, 
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