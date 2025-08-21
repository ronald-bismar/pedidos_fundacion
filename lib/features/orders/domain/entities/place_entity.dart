// lib/features/orders/domain/entities/place_entity.dart
import 'package:uuid/uuid.dart'; // Asegúrate de añadir el paquete uuid a tu pubspec.yaml

class PlaceEntity {
  final String id;
  String name;
  bool isActive; // Para controlar si el lugar está "visible" o "activo"

  PlaceEntity({
    required this.id,
    required this.name,
    this.isActive = true, // Por defecto, un lugar está activo
  });

  // Método para copiar el objeto con posibles nuevos valores
  PlaceEntity copyWith({
    String? id,
    String? name,
    bool? isActive,
  }) {
    return PlaceEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
    );
  }

  // Método para comparar igualdad (útil para `contains`)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaceEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}