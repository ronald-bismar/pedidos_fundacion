import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/place_entity.dart';

class PlaceModel extends PlaceEntity {
  PlaceModel({
    required super.id,
    required super.country,
    required super.department,
    required super.province,
    required super.city,
    required super.state,
    required super.registrationDate,
    required super.lastModifiedDate,
    super.deletDate,
    super.restorationDate,
    super.blockDate,
    super.isSyncedToLocal,
    super.isSyncedToFirebase,
  });

  factory PlaceModel.fromEntity(PlaceEntity entity) {
    return PlaceModel(
      id: entity.id,
      country: entity.country,
      department: entity.department,
      province: entity.province,
      city: entity.city,
      state: entity.state,
      registrationDate: entity.registrationDate,
      lastModifiedDate: entity.lastModifiedDate,
      deletDate: entity.deletDate,
      restorationDate: entity.restorationDate,
      blockDate: entity.blockDate,
      isSyncedToLocal: entity.isSyncedToLocal,
      isSyncedToFirebase: entity.isSyncedToFirebase,
    );
  }

  factory PlaceModel.fromMap(Map<String, dynamic> map) {
    return PlaceModel(
      id: map['id'],
      country: map['country'] ?? '',
      department: map['department'] ?? '',
      province: map['province'] ?? '',
      city: map['city'] ?? '',
      state: PlaceState.values[map['state'] as int],
      registrationDate: DateTime.parse(map['registration_date']),
      deletDate: map['delet_date'] != null
          ? DateTime.parse(map['delet_date'])
          : null,
      lastModifiedDate: DateTime.parse(map['last_modified_date']),
      restorationDate: map['restoration_date'] != null
          ? DateTime.parse(map['restoration_date'])
          : null,
      blockDate: map['block_date'] != null
          ? DateTime.parse(map['block_date'])
          : null,
      isSyncedToLocal: (map['is_synced_to_local'] as int) == 1,
      isSyncedToFirebase: (map['is_synced_to_firebase'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'country': country,
      'department': department,
      'province': province,
      'city': city,
      'state': state.index,
      'registration_date': registrationDate.toIso8601String(),
      'delet_date': deletDate?.toIso8601String(),
      'last_modified_date': lastModifiedDate.toIso8601String(),
      'restoration_date': restorationDate?.toIso8601String(),
      'block_date': blockDate?.toIso8601String(),
      'is_synced_to_local': isSyncedToLocal! ? 1 : 0,
      'is_synced_to_firebase': isSyncedToFirebase! ? 1 : 0,
    };
  }

  factory PlaceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PlaceModel(
      id: doc.id,
      country: data['country'] ?? '',
      department: data['department'] ?? '',
      province: data['province'] ?? '',
      city: data['city'] ?? '',
      state: PlaceState.values[data['state'] ?? 0],
      registrationDate: (data['registration_date'] as Timestamp).toDate(),
      lastModifiedDate: (data['last_modified_date'] as Timestamp).toDate(),
      deletDate: (data['delet_date'] as Timestamp?)?.toDate(),
      restorationDate: (data['restoration_date'] as Timestamp?)?.toDate(),
      blockDate: (data['block_date'] as Timestamp?)?.toDate(),
      // ⚡ Todo lo que viene de Firestore ya está sincronizado
      isSyncedToLocal: true,
      isSyncedToFirebase: true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'country': country,
      'department': department,
      'province': province,
      'city': city,
      'state': state.index,
      'registration_date': Timestamp.fromDate(registrationDate),
      'last_modified_date': Timestamp.fromDate(lastModifiedDate),
      'delet_date': deletDate != null ? Timestamp.fromDate(deletDate!) : null,
      'restoration_date': restorationDate != null
          ? Timestamp.fromDate(restorationDate!)
          : null,
      'block_date': blockDate != null ? Timestamp.fromDate(blockDate!) : null,
      // 🚫 NO mandamos los flags de sincronización a Firebase
    };
  }
}
