// lib/features/orders/domain/entities/place_entity.dart
import 'package:uuid/uuid.dart';
import 'dart:convert';

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
  });

  // Constructor para la creación de una nueva entidad en la aplicación
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
      deletDate: null,
      restorationDate: null,
      blockDate: null,
    );
  }

  // Cambiado de fromJson a fromMap para la base de datos local
  factory PlaceEntity.fromMap(Map<String, dynamic> map) {
    return PlaceEntity(
      id: map['id'],
      country: map['country'] ?? '',
      department: map['department'] ?? '',
      province: map['province'] ?? '',
      city: map['city'] ?? '',
      // Convierte el entero de la base de datos al valor del enum
      state: PlaceState.values[map['state'] as int],
      registrationDate: DateTime.parse(map['registration_date']),
      deletDate:
          map['delet_date'] != null ? DateTime.parse(map['delet_date']) : null,
      lastModifiedDate: DateTime.parse(map['last_modified_date']),
      restorationDate: map['restoration_date'] != null
          ? DateTime.parse(map['restoration_date'])
          : null,
      blockDate:
          map['block_date'] != null ? DateTime.parse(map['block_date']) : null,
    );
  }

  // Cambiado de toJson a toMap para la base de datos local
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'country': country,
      'department': department,
      'province': province,
      'city': city,
      'state': state.index, // Guarda el índice del enum (entero)
      'registration_date': registrationDate.toIso8601String(),
      'delet_date': deletDate?.toIso8601String(),
      'last_modified_date': lastModifiedDate.toIso8601String(),
      'restoration_date': restorationDate?.toIso8601String(),
      'block_date': blockDate?.toIso8601String(),
    };
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
    );
  }
}