// lib/features/orders/presentation/notifiers/place_notifier.dart

import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/place_entity.dart';
import '../../domain/usecases/add_place_usecase.dart';
import '../../domain/usecases/get_places_usecase.dart';
import '../../domain/usecases/update_place_usecase.dart';
import '../../domain/usecases/delete_place_usecase.dart';
import '../../domain/usecases/restore_place_usecase.dart';
import '../../domain/usecases/block_place_usecase.dart';
import '../../domain/usecases/sync_places_usecase.dart';
import '../providers/place_providers.dart';

class PlaceNotifier extends AsyncNotifier<List<PlaceEntity>> {
  @override
  Future<List<PlaceEntity>> build() async {
    log('Iniciando carga y sincronización de datos...');
    final syncPlacesUseCase = await ref.watch(syncPlacesUseCaseProvider.future);
    final getPlacesUseCase = await ref.watch(getPlacesUseCaseProvider.future);
    
    await syncPlacesUseCase.call();
    return await getPlacesUseCase.call();
  }

  Future<void> refreshData() async {
    await ref.container.refresh(placeNotifierProvider.future);
  }

  Future<void> addPlace({
    required String country,
    required String department,
    required String province,
    required String city,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final addPlaceUseCase = await ref.read(addPlaceUseCaseProvider.future);
      final getPlacesUseCase = await ref.read(getPlacesUseCaseProvider.future);
      await addPlaceUseCase.call(
        country: country,
        department: department,
        province: province,
        city: city,
      );
      return await getPlacesUseCase.call();
    });
  }

  Future<void> updatePlace(PlaceEntity updatedPlace) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updatePlaceUseCase = await ref.read(updatePlaceUseCaseProvider.future);
      final getPlacesUseCase = await ref.read(getPlacesUseCaseProvider.future);
      await updatePlaceUseCase.call(updatedPlace);
      return await getPlacesUseCase.call();
    });
  }

  Future<void> deletePlace(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final deletePlaceUseCase = await ref.read(deletePlaceUseCaseProvider.future);
      final getPlacesUseCase = await ref.read(getPlacesUseCaseProvider.future);
      await deletePlaceUseCase.call(id);
      return await getPlacesUseCase.call();
    });
  }

  Future<void> restorePlace(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final restorePlaceUseCase = await ref.read(restorePlaceUseCaseProvider.future);
      final getPlacesUseCase = await ref.read(getPlacesUseCaseProvider.future);
      await restorePlaceUseCase.call(id);
      return await getPlacesUseCase.call();
    });
  }

  Future<void> blockPlace(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final blockPlaceUseCase = await ref.read(blockPlaceUseCaseProvider.future);
      final getPlacesUseCase = await ref.read(getPlacesUseCaseProvider.future);
      await blockPlaceUseCase.call(id);
      return await getPlacesUseCase.call();
    });
  }
}

final placeNotifierProvider = AsyncNotifierProvider<PlaceNotifier, List<PlaceEntity>>(() {
  return PlaceNotifier();
});