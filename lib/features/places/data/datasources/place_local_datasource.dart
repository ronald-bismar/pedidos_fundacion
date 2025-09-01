import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/place_entity.dart';
import '../../data/models/place_model.dart';

abstract class PlaceLocalDataSource {
  Future<List<PlaceEntity>> getPlaces();
  Future<void> addPlace(PlaceEntity place);
  Future<void> updatePlace(PlaceEntity place);
  Future<void> deletePlace(PlaceEntity place);
  Future<void> blockPlace(PlaceEntity place);
  Future<void> restorePlace(PlaceEntity place);
  Future<List<PlaceModel>> getPlacesToSync();
  Future<void> syncPlaceToFirebase(PlaceModel place, {int retries = 3});
  Future<void> syncPendingPlaces();
}

class PlaceLocalDataSourceImpl implements PlaceLocalDataSource {
  final Database db;
  final CollectionReference _placesCollection =
      FirebaseFirestore.instance.collection('places');

  PlaceLocalDataSourceImpl(this.db);

  static const String places = '''
  CREATE TABLE places(
    id TEXT PRIMARY KEY,
    country TEXT,
    department TEXT,
    province TEXT,
    city TEXT,
    state INTEGER,
    registration_date TEXT,
    delet_date TEXT,
    last_modified_date TEXT,
    restoration_date TEXT,
    block_date TEXT,
    is_synced_to_local INTEGER,
    is_synced_to_firebase INTEGER
  )
''';

  @override
  Future<void> addPlace(PlaceEntity place) async {
    final model = PlaceModel.fromEntity(place);
    await db.insert(
      'places',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await syncPlaceToFirebase(model);
  }

  @override
  Future<void> updatePlace(PlaceEntity place) async {
    final model = PlaceModel.fromEntity(place);
    await db.update(
      'places',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [place.id],
    );

    await syncPlaceToFirebase(model);
  }

  @override
  Future<void> deletePlace(PlaceEntity place) async {
    await db.update(
      'places',
      {
        'state': PlaceState.deleted.index,
        'delet_date': DateTime.now().toIso8601String(),
        'last_modified_date': DateTime.now().toIso8601String(),
        'is_synced_to_local': 0,
      },
      where: 'id = ?',
      whereArgs: [place.id],
    );
  }

  @override
  Future<void> blockPlace(PlaceEntity place) async {
    await db.update(
      'places',
      {
        'state': PlaceState.blocked.index,
        'block_date': DateTime.now().toIso8601String(),
        'last_modified_date': DateTime.now().toIso8601String(),
        'is_synced_to_local': 0,
      },
      where: 'id = ?',
      whereArgs: [place.id],
    );
  }

  @override
  Future<void> restorePlace(PlaceEntity place) async {
    await db.update(
      'places',
      {
        'state': PlaceState.active.index,
        'delet_date': null,
        'restoration_date': DateTime.now().toIso8601String(),
        'last_modified_date': DateTime.now().toIso8601String(),
        'is_synced_to_local': 0,
      },
      where: 'id = ?',
      whereArgs: [place.id],
    );
  }

  @override
  Future<List<PlaceEntity>> getPlaces() async {
    final maps = await db.query('places');
    return maps.map((m) => PlaceModel.fromMap(m)).toList();
  }

  @override
  Future<List<PlaceModel>> getPlacesToSync() async {
    final maps = await db.query(
      'places',
      where: 'is_synced_to_local = ?',
      whereArgs: [0],
    );
    return maps.map((m) => PlaceModel.fromMap(m)).toList();
  }

  @override
  Future<void> syncPlaceToFirebase(PlaceModel place, {int retries = 3}) async {
    int attempt = 0;
    while (attempt < retries) {
      try {
        await _placesCollection.doc(place.id).set(place.toFirestore());
        await db.update(
          'places',
          {'is_synced_to_local': 1, 'is_synced_to_firebase': 1},
          where: 'id = ?',
          whereArgs: [place.id],
        );
        print('Sincronización exitosa para lugar: ${place.id}');
        return;
      } catch (e) {
        attempt++;
        print('Error sincronizando lugar a Firebase (intento $attempt): $e');
        if (attempt >= retries) {
          print('Se agotaron los reintentos para ${place.id}, quedará pendiente');
        }
        await Future.delayed(const Duration(seconds: 2)); // esperar antes de reintentar
      }
    }
  }

  @override
  Future<void> syncPendingPlaces() async {
    final pending = await getPlacesToSync();
    for (final place in pending) {
      await syncPlaceToFirebase(place);
    }
  }
}
