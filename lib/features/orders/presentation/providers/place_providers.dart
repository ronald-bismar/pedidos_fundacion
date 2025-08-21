// lib/features/orders/presentation/providers/place_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/features/orders/domain/entities/place_entity.dart';
import 'package:uuid/uuid.dart';


// Provider y Notifier siguen siendo los mismos
final placeProvider = StateNotifierProvider<PlaceNotifier, List<PlaceEntity>>((ref) {
  return PlaceNotifier();
});

class PlaceNotifier extends StateNotifier<List<PlaceEntity>> {
  PlaceNotifier() : super([]);

  void addPlace(String name) {
    final normalizedName = name.trim().toLowerCase();
    if (!state.any((place) => place.name.trim().toLowerCase() == normalizedName)) {
      state = [...state, PlaceEntity(id: const Uuid().v4(), name: name.trim())];
    }
  }

  void updatePlace(PlaceEntity updatedPlace) {
    state = [
      for (final place in state)
        if (place.id == updatedPlace.id) updatedPlace else place,
    ];
  }

  void removePlace(String id) {
    state = state.where((place) => place.id != id).toList();
  }

  void togglePlaceActiveStatus(String id) {
    state = [
      for (final place in state)
        if (place.id == id) place.copyWith(isActive: !place.isActive) else place,
    ];
  }

  List<PlaceEntity> get activePlaces => state.where((place) => place.isActive).toList();
}