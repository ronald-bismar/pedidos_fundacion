import 'package:sqflite/sqflite.dart';
import '../../domain/entities/place_entity.dart';

abstract class PlaceLocalDataSource {
  Future<List<PlaceEntity>> getPlaces();
  Future<void> addPlace(PlaceEntity place);
  Future<void> updatePlace(PlaceEntity place);
  Future<void> deletePlace(String id);
  Future<void> blockPlace(String id);
  Future<void> restorePlace(String id);
}

class PlaceLocalDataSourceImpl implements PlaceLocalDataSource {
  final Database db;

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
      block_date TEXT
    )
  ''';

  @override
  Future<void> addPlace(PlaceEntity place) async {
    // Usamos el método toMap() de la entidad para la conversión
    await db.insert(
      'places',
      place.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updatePlace(PlaceEntity place) async {
    await db.update(
      'places',
      place.toMap(),
      where: 'id = ?',
      whereArgs: [place.id],
    );
  }

  @override
  Future<void> deletePlace(String id) async {
    await db.update(
      'places',
      {
        'state': PlaceState.deleted.index,
        'delet_date': DateTime.now().toIso8601String(),
        'last_modified_date': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> restorePlace(String id) async {
    await db.update(
      'places',
      {
        'state': PlaceState.active.index,
        'restoration_date': DateTime.now().toIso8601String(),
        'last_modified_date': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> blockPlace(String id) async {
    await db.update(
      'places',
      {
        'state': PlaceState.blocked.index,
        'block_date': DateTime.now().toIso8601String(),
        'last_modified_date': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<PlaceEntity>> getPlaces() async {
    final List<Map<String, dynamic>> maps = await db.query('places');
    return List.generate(maps.length, (i) {
      // Usamos el constructor factory para convertir el Map a una entidad
      return PlaceEntity.fromMap(maps[i]);
    });
  }
}