import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/place_entity.dart';

class PlaceRemoteDataSource {
  final _placesCollection = FirebaseFirestore.instance.collection('places');

  Future<PlaceEntity> addPlace(PlaceEntity place) async {
    final newDocRef = await _placesCollection.add(place.toFirestore());
    return place.copyWith(id: newDocRef.id);
  }

  Future<void> updatePlace(PlaceEntity place) async {
    await _placesCollection.doc(place.id).update(place.toFirestore());
  }

  Future<void> deletePlace(String id) async {
    await _placesCollection.doc(id).update({
      'state': PlaceState.deleted.index,
      'delet_date': DateTime.now(), 
      'last_modified_date': DateTime.now(), 
    });
  }

  Future<void> restorePlace(String id) async {
    await _placesCollection.doc(id).update({
      'state': PlaceState.active.index,
      'delet_date': null, 
      'restoration_date': DateTime.now(), 
      'last_modified_date': DateTime.now(),
    });
  }

  Future<void> blockPlace(String id) async {
    await _placesCollection.doc(id).update({
      'state': PlaceState.blocked.index,
      'block_date': DateTime.now(), 
      'last_modified_date': DateTime.now(),
    });
  }

  Future<List<PlaceEntity>> getPlaces() async {
    final snapshot = await _placesCollection.get();
    return snapshot.docs.map((doc) => PlaceEntity.fromFirestore(doc)).toList();
  }
}
  