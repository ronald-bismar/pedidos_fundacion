// lib/features/orders/presentation/providers/place_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/place_entity.dart';

final placeProvider = StateNotifierProvider<PlaceNotifier, List<PlaceEntity>>((
  ref,
) {
  return PlaceNotifier();
});

class PlaceNotifier extends StateNotifier<List<PlaceEntity>> {
  PlaceNotifier() : super([]);

  /// Adds a new place to the list.
  void addPlace({
    required String country,
    required String department,
    required String province,
    required String city,
  }) {
    final newPlace = PlaceEntity(
      id: const Uuid().v4(),
      country: country.trim(),
      department: department.trim(),
      province: province.trim(),
      city: city.trim(),
      registrationDate: DateTime.now(),
    );
    // Creates a new list and adds the new place
    state = [...state, newPlace];
  }

  /// Updates an existing place by creating a new list.
  void updatePlace(PlaceEntity updatedPlace) {
    state = [
      for (final place in state)
        if (place.id == updatedPlace.id)
          // Creates and replaces the place instance
          updatedPlace.copyWith(editedDate: DateTime.now())
        else
          place,
    ];
  }

  /// Marks a place as deleted by changing its state.
  void deletePlace(String id) {
    state = [
      for (final place in state)
        if (place.id == id)
          place.copyWith(state: PlaceState.deleted, deleteDate: DateTime.now())
        else
          place,
    ];
  }

  /// Changes the state of the place to "blocked".
  void blockPlace(String id) {
    state = [
      for (final place in state)
        if (place.id == id)
          place.copyWith(state: PlaceState.blocked, editedDate: DateTime.now())
        else
          place,
    ];
  }

  /// Changes the state of the place to "active".
  void unblockPlace(String id) {
    state = [
      for (final place in state)
        if (place.id == id)
          place.copyWith(state: PlaceState.active, editedDate: DateTime.now())
        else
          place,
    ];
  }

  List<PlaceEntity> get activePlaces =>
      state.where((place) => place.state == PlaceState.active).toList();
  List<PlaceEntity> get inactivePlaces =>
      state.where((place) => place.state == PlaceState.blocked).toList();
  List<PlaceEntity> get deletedPlaces =>
      state.where((place) => place.state == PlaceState.deleted).toList();
}