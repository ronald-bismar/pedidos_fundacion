import 'package:sqflite/sqflite.dart';
import '../../domain/entities/place_entity.dart';

abstract class PlaceLocalDataSource {
  Future<List<PlaceEntity>> getPlaces();
  Future<void> addPlace(PlaceEntity place);
  Future<void> updatePlace(PlaceEntity place);
  Future<void> deletePlace(PlaceEntity place);
  Future<void> blockPlace(PlaceEntity place);
  Future<void> restorePlace(PlaceEntity place);
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
    block_date TEXT,
    is_synced_to_local INTEGER,
    is_synced_to_firebase INTEGER
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
  Future<void> deletePlace(PlaceEntity place) async {
    await db.update(
      'places',
      place.toMap(), // Ahora pasamos el mapa de la entidad completa
      where: 'id = ?',
      whereArgs: [place.id],
    );
  }

  @override
  Future<void> restorePlace(PlaceEntity place) async {
    await db.update(
      'places',
      place.toMap(), // Ahora pasamos el mapa de la entidad completa
      where: 'id = ?',
      whereArgs: [place.id],
    );
  }

  @override
  Future<void> blockPlace(PlaceEntity place) async {
    await db.update(
      'places',
      place.toMap(), // Ahora pasamos el mapa de la entidad completa
      where: 'id = ?',
      whereArgs: [place.id],
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