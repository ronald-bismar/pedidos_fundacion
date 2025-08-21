// lib/features/orders/domain/entities/place_entity.dart
import 'package:uuid/uuid.dart';

// Enumerador para los estados del lugar
enum PlaceState { active, deleted, blocked }

class PlaceEntity {
  final String id;
  final String name;
  final String country;
  final String department;
  final String? city;
  final PlaceState state;
  final DateTime registrationDate;
  final DateTime? editedDate;
  final DateTime? deleteDate;
  final DateTime? restorationDate;

  PlaceEntity({
    required this.id,
    required this.name,
    required this.country,
    required this.department,
    this.city,
    this.state = PlaceState.active,
    required this.registrationDate,
    this.editedDate,
    this.deleteDate,
    this.restorationDate,
  });

  // Método para crear una nueva instancia con cambios
  PlaceEntity copyWith({
    String? id,
    String? name,
    String? country,
    String? department,
    String? city,
    PlaceState? state,
    DateTime? registrationDate,
    DateTime? editedDate,
    DateTime? deleteDate,
    DateTime? restorationDate,
  }) {
    return PlaceEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      department: department ?? this.department,
      city: city ?? this.city,
      state: state ?? this.state,
      registrationDate: registrationDate ?? this.registrationDate,
      editedDate: editedDate ?? this.editedDate,
      deleteDate: deleteDate ?? this.deleteDate,
    );
  }

  // Sobrescribe los operadores de igualdad para una comparación correcta
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaceEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
