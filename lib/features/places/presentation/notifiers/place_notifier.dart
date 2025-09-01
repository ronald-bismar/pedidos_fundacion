// lib/features/orders/presentation/notifiers/place_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/place_entity.dart';
import '../../domain/usecases/add_place_usecase.dart';
import '../../domain/usecases/get_places_usecase.dart';
import '../../domain/usecases/update_place_usecase.dart';
import '../../domain/usecases/delete_place_usecase.dart';
import '../../domain/usecases/restore_place_usecase.dart';
import '../../domain/usecases/block_place_usecase.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class PlaceNotifier extends StateNotifier<List<PlaceEntity>> {
  final GetPlacesUseCase getPlacesUseCase;
  final AddPlaceUseCase addPlaceUseCase;
  final UpdatePlaceUseCase updatePlaceUseCase;
  final DeletePlaceUseCase deletePlaceUseCase;
  final RestorePlaceUseCase restorePlaceUseCase;
  final BlockPlaceUseCase blockPlaceUseCase;

  PlaceNotifier({
    required this.getPlacesUseCase,
    required this.addPlaceUseCase,
    required this.updatePlaceUseCase,
    required this.deletePlaceUseCase,
    required this.restorePlaceUseCase,
    required this.blockPlaceUseCase,
  }) : super([]) {
    loadPlaces();
  }

  Future<void> loadPlaces() async {
    try {
      final places = await getPlacesUseCase();
      state = places;
      print('¡Lugares cargados con éxito! Total de lugares: ${state.length}');
    } catch (e) {
      print('Error cargando lugares: $e');
      state = [];
    }
  }

 Future<void> addPlace({
    required String country,
    required String department,
    required String province,
    required String city,
  }) async {
    // Verificar la conexión a internet antes de intentar guardar en Firebase
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // mostrar un mensaje de error al usuario
      print('No hay conexión a internet. No se puede guardar el lugar.');
      return;
    }
    
    // Si hay conexión, se procede con la lógica de guardar en la nube
    await addPlaceUseCase(
      country: country,
      department: department,
      province: province,
      city: city,
    );
    await loadPlaces();
  }

  Future<void> updatePlace(PlaceEntity updatedPlace) async {
    await updatePlaceUseCase(updatedPlace);
    await loadPlaces();
  }

  Future<void> deletePlace(String id) async {
    await deletePlaceUseCase(id);
    await loadPlaces();
  }

  Future<void> restorePlace(PlaceEntity place) async {
    await restorePlaceUseCase(place.id);
    await loadPlaces();
  }

  Future<void> blockPlace(String id) async {
    await blockPlaceUseCase(id);
    await loadPlaces();
  }
}