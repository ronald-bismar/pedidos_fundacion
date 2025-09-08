import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/place_entity.dart';

class PlaceRemoteDataSource {
  final _placesCollection = FirebaseFirestore.instance.collection('places');

  Future<void> addPlace(PlaceEntity place) async {
    // Usamos el método toMap() que ya convierte el enum a int y la fecha a Timestamp
    await _placesCollection.doc(place.id).set(place.toMap());
  }

  Future<void> updatePlace(PlaceEntity place) async {
    await _placesCollection.doc(place.id).update(place.toMap());
  }

  Future<void> deletePlace(String id) async {
    await _placesCollection.doc(id).update({
      'state': PlaceState.deleted.index, // Usar el índice del enum
      'delet_date': DateTime.now(), // El SDK lo convierte a Timestamp
      'last_modified_date': DateTime.now(), // Añadimos esto para un mejor seguimiento
    });
  }

  Future<void> restorePlace(String id) async {
    await _placesCollection.doc(id).update({
      'state': PlaceState.active.index, // Usar el índice del enum
      'delet_date': null, // Firebase elimina el campo si el valor es null
      'restoration_date': DateTime.now(), // El SDK lo convierte a Timestamp
      'last_modified_date': DateTime.now(),
    });
  }

  Future<void> blockPlace(String id) async {
    await _placesCollection.doc(id).update({
      'state': PlaceState.blocked.index, // Usar el índice del enum
      'block_date': DateTime.now(), // El SDK lo convierte a Timestamp
      'last_modified_date': DateTime.now(),
    });
  }

  Future<List<PlaceEntity>> getPlaces() async {
    final snapshot = await _placesCollection.get();
    return snapshot.docs.map((doc) => PlaceEntity.fromMap(doc.data())).toList();
  }
}