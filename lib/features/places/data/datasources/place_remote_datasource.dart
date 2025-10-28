// lib/features/orders/data/datasources/place_remote_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/place_entity.dart';

class PlaceRemoteDataSource {
  final _placesCollection = FirebaseFirestore.instance.collection('places');

  Future<void> addPlace(PlaceEntity place) async {
    print('Guardando en Firebase: ${place.toFirestore()}');
    await _placesCollection.doc(place.id).set(place.toFirestore());
    print('Guardado exitoso en Firebase: ${place.id}');
  }

  Future<void> updatePlace(PlaceEntity place) async {
    await _placesCollection.doc(place.id).update(place.toFirestore());
  }

  Future<void> deletePlace(String id) async {
    await _placesCollection.doc(id).update({
      'state': PlaceState.deleted.value, 
      'delet_date': Timestamp.fromDate(DateTime.now()),
      'last_modified_date': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> blockPlace(String id) async {
    await _placesCollection.doc(id).update({
      'state': PlaceState.blocked.value,
      'block_date': Timestamp.fromDate(DateTime.now()),
      'last_modified_date': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> restorePlace(String id) async {
    await _placesCollection.doc(id).update({
      'state': PlaceState.active.value,
      'delet_date': null,
      'restoration_date': Timestamp.fromDate(DateTime.now()),
      'last_modified_date': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<List<PlaceEntity>> getPlaces() async {
    final snapshot = await _placesCollection.get();
    return snapshot.docs
        .map(
          (doc) => PlaceEntity.fromFirestore(doc),
        )
        .toList();
  }

  Future<List<PlaceEntity>> getPlacesByGroupId(String groupId) async {
    final snapshot = await _placesCollection.where('group_id', isEqualTo: groupId).get();
    return snapshot.docs
        .map(
          (doc) => PlaceEntity.fromFirestore(doc),
        )
        .toList();
  }
}