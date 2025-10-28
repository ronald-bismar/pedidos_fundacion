// lib/features/orders/data/datasources/place_local_datasource.dart

import 'package:sqflite/sqflite.dart';
import '../../domain/entities/place_entity.dart';
import 'dart:developer'; // Necesario para los logs

abstract class PlaceLocalDataSource {
  Future<List<PlaceEntity>> getPlaces(); // Obtiene todos los lugares almacenados localmente
  Future<void> addPlace(PlaceEntity place); // Inserta un nuevo lugar en la base de datos local
  Future<void> updatePlace(PlaceEntity place); // Actualiza los datos de un lugar existente
  Future<void> deletePlace(String id); // Marca un lugar como eliminado (soft delete)
  Future<void> hardDeletePlace(String id); // Elimina un lugar permanentemente de la base de datos
  Future<void> blockPlace(PlaceEntity place); // Bloquea un lugar en la base de datos
  Future<void> restorePlace(PlaceEntity place); // Restaura un lugar previamente eliminado o bloqueado
  Future<List<PlaceEntity>> getPlacesToSync(); // Obtiene los lugares pendientes de sincronización con Firebase
  Future<void> insertOrUpdate(List<PlaceEntity> places); // Inserta o actualiza en lote los lugares recibidos
}

class PlaceLocalDataSourceImpl implements PlaceLocalDataSource {
  final Database db;

  PlaceLocalDataSourceImpl(this.db);

  // Estructura SQL de la tabla 'places'
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
    // Inserta un nuevo registro en la tabla 'places'
    await db.insert(
      'places',
      place.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updatePlace(PlaceEntity place) async {
    // Actualiza los datos de un lugar identificado por su ID
    await db.update(
      'places',
      place.toMap(),
      where: 'id = ?',
      whereArgs: [place.id],
    );
  }

  @override
  Future<void> deletePlace(String id) async {
    // Realiza un "soft delete" marcando el estado como eliminado y guardando la fecha
    await db.update(
      'places',
      {
        'state': PlaceState.deleted.value,
        'delet_date': DateTime.now().toIso8601String(),
        'last_modified_date': DateTime.now().toIso8601String(),
        'is_synced_to_local': 0,
        'is_synced_to_firebase': 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> blockPlace(PlaceEntity place) async {
    // Marca un lugar como bloqueado y registra la fecha
    await db.update(
      'places',
      {
        'state': PlaceState.blocked.value,
        'block_date': DateTime.now().toIso8601String(),
        'last_modified_date': DateTime.now().toIso8601String(),
        'is_synced_to_local': 0,
        'is_synced_to_firebase': 0,
      },
      where: 'id = ?',
      whereArgs: [place.id],
    );
  }

  @override
  Future<void> restorePlace(PlaceEntity place) async {
    // Restaura un lugar activo eliminando fechas de eliminación y registrando restauración
    await db.update(
      'places',
      {
        'state': PlaceState.active.value,
        'delet_date': null,
        'restoration_date': DateTime.now().toIso8601String(),
        'last_modified_date': DateTime.now().toIso8601String(),
        'is_synced_to_local': 0,
        'is_synced_to_firebase': 0,
      },
      where: 'id = ?',
      whereArgs: [place.id],
    );
  }

  @override
  Future<void> hardDeletePlace(String id) async {
    // Elimina permanentemente un lugar de la tabla 'places'
    await db.delete(
      'places',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<PlaceEntity>> getPlaces() async {
    // Recupera todos los lugares de la base de datos
    final List<Map<String, dynamic>> maps = await db.query('places');
    return List.generate(maps.length, (i) => PlaceEntity.fromMap(maps[i]));
  }

  @override
  Future<List<PlaceEntity>> getPlacesToSync() async {
    // Obtiene los lugares que no se han sincronizado con Firebase
    final maps = await db.query(
      'places',
      where: 'is_synced_to_firebase = ?',
      whereArgs: [0],
    );
    return List.generate(maps.length, (i) => PlaceEntity.fromMap(maps[i]));
  }

  @override
  Future<void> insertOrUpdate(List<PlaceEntity> places) async {
    // Inserta o actualiza en lote una lista de lugares en la tabla 'places'
    try {
      final Batch batch = db.batch();
      for (var place in places) {
        batch.insert(
          'places',
          place.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
      log('Lote de ${places.length} lugares insertado/actualizado exitosamente.');
    } catch (e) {
      log('Error insertando o actualizando lote de lugares: $e');
      throw Exception('Failed to insert or update places batch: $e');
    }
  }
}
