// lib/features/orders/domain/entities/place_entity.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

enum PlaceState { active, deleted, blocked }

class PlaceEntity {
  final String id;
  final String country;
  final String department;
  final String province;
  final String city;
  final PlaceState state;
  final DateTime registrationDate;
  final DateTime? deletDate;
  final DateTime lastModifiedDate;
  final DateTime? restorationDate;
  final DateTime? blockDate;
  final bool isSyncedToLocal;
  final bool isSyncedToFirebase;

  PlaceEntity({
    required this.id,
    required this.country,
    required this.department,
    required this.province,
    required this.city,
    required this.state,
    required this.registrationDate,
    required this.lastModifiedDate,
    this.deletDate,
    this.restorationDate,
    this.blockDate,
    this.isSyncedToLocal = false,
    this.isSyncedToFirebase = false,
  });

  factory PlaceEntity.newPlace({
    required String country,
    required String department,
    required String province,
    required String city,
  }) {
    final now = DateTime.now();
    return PlaceEntity(
      id: const Uuid().v4(),
      country: country,
      department: department,
      province: province,
      city: city,
      state: PlaceState.active,
      registrationDate: now,
      lastModifiedDate: now,
    );
  }

  PlaceEntity copyWith({
    String? id,
    String? country,
    String? department,
    String? province,
    String? city,
    PlaceState? state,
    DateTime? registrationDate,
    DateTime? deletDate,
    DateTime? lastModifiedDate,
    DateTime? restorationDate,
    DateTime? blockDate,
    bool? isSyncedToLocal,
    bool? isSyncedToFirebase,
  }) {
    return PlaceEntity(
      id: id ?? this.id,
      country: country ?? this.country,
      department: department ?? this.department,
      province: province ?? this.province,
      city: city ?? this.city,
      state: state ?? this.state,
      registrationDate: registrationDate ?? this.registrationDate,
      deletDate: deletDate ?? this.deletDate,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
      restorationDate: restorationDate ?? this.restorationDate,
      blockDate: blockDate ?? this.blockDate,
      isSyncedToLocal: isSyncedToLocal ?? this.isSyncedToLocal,
      isSyncedToFirebase: isSyncedToFirebase ?? this.isSyncedToFirebase,
    );
  }

  // --- Métodos para SQLite / Map ---
  factory PlaceEntity.fromMap(Map<String, dynamic> map) {
    return PlaceEntity(
      id: map['id'],
      country: map['country'] ?? '',
      department: map['department'] ?? '',
      province: map['province'] ?? '',
      city: map['city'] ?? '',
      state: PlaceState.values[map['state'] ?? 0],
      registrationDate: DateTime.parse(map['registration_date']),
      lastModifiedDate: DateTime.parse(map['last_modified_date']),
      deletDate: map['delet_date'] != null ? DateTime.parse(map['delet_date']) : null,
      restorationDate: map['restoration_date'] != null ? DateTime.parse(map['restoration_date']) : null,
      blockDate: map['block_date'] != null ? DateTime.parse(map['block_date']) : null,
      isSyncedToLocal: (map['is_synced_to_local'] ?? 0) == 1,
      isSyncedToFirebase: (map['is_synced_to_firebase'] ?? 0) == 1,
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
      'last_modified_date': lastModifiedDate.toIso8601String(),
      'delet_date': deletDate?.toIso8601String(),
      'restoration_date': restorationDate?.toIso8601String(),
      'block_date': blockDate?.toIso8601String(),
      'is_synced_to_local': isSyncedToLocal ? 1 : 0,
      'is_synced_to_firebase': isSyncedToFirebase ? 1 : 0,
    };
  }

  // --- Métodos para Firestore ---
  factory PlaceEntity.fromFirestore(Map<String, dynamic> map) {
    return PlaceEntity(
      id: map['id'],
      country: map['country'] ?? '',
      department: map['department'] ?? '',
      province: map['province'] ?? '',
      city: map['city'] ?? '',
      state: PlaceState.values[map['state'] ?? 0],
      registrationDate: (map['registration_date'] as Timestamp).toDate(),
      lastModifiedDate: (map['last_modified_date'] as Timestamp).toDate(),
      deletDate: map['delet_date'] != null ? (map['delet_date'] as Timestamp).toDate() : null,
      restorationDate: map['restoration_date'] != null ? (map['restoration_date'] as Timestamp).toDate() : null,
      blockDate: map['block_date'] != null ? (map['block_date'] as Timestamp).toDate() : null,
      isSyncedToLocal: map['is_synced_to_local'] ?? false,
      isSyncedToFirebase: map['is_synced_to_firebase'] ?? false,
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
      'restoration_date': restorationDate != null ? Timestamp.fromDate(restorationDate!) : null,
      'block_date': blockDate != null ? Timestamp.fromDate(blockDate!) : null,
      'is_synced_to_local': isSyncedToLocal,
      'is_synced_to_firebase': isSyncedToFirebase,
    };
  }
}
