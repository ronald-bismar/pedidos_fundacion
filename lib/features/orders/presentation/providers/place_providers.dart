// lib/features/orders/presentation/providers/place_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/place_entity.dart';

final placeProvider = StateNotifierProvider<PlaceNotifier, List<PlaceEntity>>((ref) {
  return PlaceNotifier();
});

class PlaceNotifier extends StateNotifier<List<PlaceEntity>> {
  PlaceNotifier() : super([]);

  // Agrega un nuevo lugar con país, departamento y ciudad (opcional)
  void addPlace({
    required String name,
    required String country,
    required String department,
    String? city,
  }) {
    final normalizedName = name.trim().toLowerCase();
    if (!state.any((place) => place.name.trim().toLowerCase() == normalizedName)) {
      final newPlace = PlaceEntity(
        id: const Uuid().v4(),
        name: name.trim(),
        country: country,
        department: department,
        city: city,
        registrationDate: DateTime.now(),
      );
      state = [...state, newPlace];
    }
  }

  // Actualiza un lugar existente
  void updatePlace(PlaceEntity updatedPlace) {
    state = [
      for (final place in state)
        if (place.id == updatedPlace.id)
          updatedPlace.copyWith(editedDate: DateTime.now())
        else
          place,
    ];
  }

  // "Elimina" un lugar cambiando su estado a `deleted`
  void deletePlace(String id) {
    state = [
      for (final place in state)
        if (place.id == id)
          place.copyWith(state: PlaceState.deleted, deleteDate: DateTime.now())
        else
          place,
    ];
  }

  // Bloquea un lugar cambiando su estado a `inactive`
  void blockPlace(String id) {
    state = [
      for (final place in state)
        if (place.id == id)
          place.copyWith(state: PlaceState.blocked)
        else
          place,
    ];
  }

  // Desbloquea un lugar cambiando su estado a `active`
  void unblockPlace(String id) {
    state = [
      for (final place in state)
        if (place.id == id)
          place.copyWith(state: PlaceState.active, restorationDate: DateTime.now())
        else
          place,
    ];
  }

  // Getters para filtrar lugares por estado
  List<PlaceEntity> get activePlaces => state.where((place) => place.state == PlaceState.active).toList();
  List<PlaceEntity> get inactivePlaces => state.where((place) => place.state == PlaceState.blocked).toList();
  List<PlaceEntity> get deletedPlaces => state.where((place) => place.state == PlaceState.deleted).toList();
}