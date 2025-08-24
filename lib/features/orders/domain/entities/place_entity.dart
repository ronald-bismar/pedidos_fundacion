// lib/features/orders/domain/entities/place_entity.dart
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
  final DateTime? blockDate; // Nuevo campo para el estado bloqueado

  PlaceEntity({
    String? id,
    required this.country,
    required this.department,
    required this.province,
    required this.city,
    this.state = PlaceState.active,
    DateTime? registrationDate,
    this.deletDate,
    DateTime? lastModifiedDate,
    this.restorationDate,
    this.blockDate, // Nuevo campo
  })  : this.id = id ?? const Uuid().v4(),
        this.registrationDate = registrationDate ?? DateTime.now(),
        this.lastModifiedDate = lastModifiedDate ?? DateTime.now();

  factory PlaceEntity.fromJson(Map<String, dynamic> json) => PlaceEntity(
        id: json['id'],
        country: json['country'] ?? '',
        department: json['department'] ?? '',
        province: json['province'] ?? '',
        city: json['city'] ?? '',
        state: PlaceState.values.firstWhere(
          (e) => e.toString().split('.').last == json['state'],
          orElse: () => PlaceState.active,
        ),
        registrationDate: DateTime.parse(json['registration_date']),
        deletDate:
            json['delet_date'] != null ? DateTime.parse(json['delet_date']) : null,
        lastModifiedDate: DateTime.parse(json['last_modified_date']),
        restorationDate: json['restoration_date'] != null
            ? DateTime.parse(json['restoration_date'])
            : null,
        blockDate: json['block_date'] != null
            ? DateTime.parse(json['block_date'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'country': country,
        'department': department,
        'province': province,
        'city': city,
        'state': state.name,
        'registration_date': registrationDate.toIso8601String(),
        'delet_date': deletDate?.toIso8601String(),
        'last_modified_date': lastModifiedDate.toIso8601String(),
        'restoration_date': restorationDate?.toIso8601String(),
        'block_date': blockDate?.toIso8601String(),
      };

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