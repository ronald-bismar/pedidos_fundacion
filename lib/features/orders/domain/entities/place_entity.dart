// lib/features/orders/domain/entities/place_entity.dart
import 'package:uuid/uuid.dart';

// Enumerator for the place states
enum PlaceState { active, deleted, blocked }

class PlaceEntity {
  final String id;
  final String country;
  final String department;
  final String province;
  final String city;
  final PlaceState state;
  final DateTime registrationDate;
  final DateTime? editedDate;
  final DateTime? deleteDate;
  final DateTime? restorationDate;

  PlaceEntity({
    required this.id,
    required this.country,
    required this.department,
    required this.province,
    required this.city,
    this.state = PlaceState.active,
    required this.registrationDate,
    this.editedDate,
    this.deleteDate,
    this.restorationDate,
  });

  // Method to create a new instance with changes
  PlaceEntity copyWith({
    String? id,
    String? country,
    String? department,
    String? province,
    String? city,
    PlaceState? state,
    DateTime? registrationDate,
    DateTime? editedDate,
    DateTime? deleteDate,
    DateTime? restorationDate,
  }) {
    return PlaceEntity(
      id: id ?? this.id,
      country: country ?? this.country,
      department: department ?? this.department,
      province: province ?? this.province,
      city: city ?? this.city,
      state: state ?? this.state,
      registrationDate: registrationDate ?? this.registrationDate,
      editedDate: editedDate ?? this.editedDate,
      deleteDate: deleteDate ?? this.deleteDate,
      restorationDate: restorationDate ?? this.restorationDate,
    );
  }

  // Overrides the equality operators for correct comparison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaceEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'PlaceEntity(id: $id, country: $country, department: $department, province: $province, city: $city, state: $state)';
  }
}