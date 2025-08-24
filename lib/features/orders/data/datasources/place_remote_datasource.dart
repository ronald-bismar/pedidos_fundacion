// lib/features/orders/data/datasources/place_remote_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/place_entity.dart';
// Importa el archivo de mapeo si usas uno
// import '../mappers/place_mapper.dart'; 

class PlaceRemoteDataSource {
  final _placesCollection = FirebaseFirestore.instance.collection('places');

  Future<void> addPlace(PlaceEntity place) async {
    // Si tienes un método toJson() en tu entidad, úsalo directamente.
    // O puedes usar un PlaceMapper.toMap(place)
    await _placesCollection.doc(place.id).set(place.toJson());
  }

  Future<void> updatePlace(PlaceEntity place) async {
    await _placesCollection.doc(place.id).update(place.toJson());
  }

  Future<void> deletePlace(String id) async {
    // Para no eliminar permanentemente, actualizamos el estado.
    await _placesCollection.doc(id).update({
      'state': PlaceState.deleted.name,
      'delet_date': DateTime.now().toIso8601String(),
    });
  }

  Future<void> restorePlace(PlaceEntity place) async {
    // Restauramos el lugar cambiando su estado.
    await _placesCollection.doc(place.id).update({
      'state': PlaceState.active.name,
      'delet_date': null,
      'restoration_date': DateTime.now().toIso8601String(),
    });
  }

  Future<List<PlaceEntity>> getPlaces() async {
    final snapshot = await _placesCollection.get();
    return snapshot.docs
        .map((doc) => PlaceEntity.fromJson(doc.data()))
        .toList();
  }

  Future<void> blockPlace(String id) async {
    // Implementación para bloquear un lugar
    await _placesCollection.doc(id).update({
      'state': PlaceState.blocked.name,
      'block_date': DateTime.now().toIso8601String(),
    });
  }
}