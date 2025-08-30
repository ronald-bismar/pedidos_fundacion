import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/place_entity.dart';

class PlaceRemoteDataSource {
  final _placesCollection = FirebaseFirestore.instance.collection('places');

  // Future<PlaceEntity> addPlace(PlaceEntity place) async {
  //   await _placesCollection.doc(place.id).set(place.toFirestore());
  //   return place.copyWith(isSyncedToFirebase: true);
  // }
  Future<PlaceEntity> addPlace(PlaceEntity place) async {
    print('Guardando en Firebase: ${place.toFirestore()}');
    await _placesCollection.doc(place.id).set(place.toFirestore());
    print('Guardado exitoso en Firebase: ${place.id}');
    return place.copyWith(isSyncedToFirebase: true);
  }



  Future<void> updatePlace(PlaceEntity place) async {
    await _placesCollection.doc(place.id).update(place.toFirestore());
  }

  Future<void> deletePlace(String id) async {
    await _placesCollection.doc(id).update({
      'state': PlaceState.deleted.index,
      'delet_date': Timestamp.fromDate(DateTime.now()),
      'last_modified_date': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> blockPlace(String id) async {
    await _placesCollection.doc(id).update({
      'state': PlaceState.blocked.index,
      'block_date': Timestamp.fromDate(DateTime.now()),
      'last_modified_date': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> restorePlace(String id) async {
    await _placesCollection.doc(id).update({
      'state': PlaceState.active.index,
      'delet_date': null,
      'restoration_date': Timestamp.fromDate(DateTime.now()),
      'last_modified_date': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<List<PlaceEntity>> getPlaces() async {
    final snapshot = await _placesCollection.get();
    return snapshot.docs
        .map(
          (doc) =>
              PlaceEntity.fromFirestore(doc.data() as Map<String, dynamic>),
        )
        .toList();
  }
}
