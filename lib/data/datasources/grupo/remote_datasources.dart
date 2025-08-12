import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/di/services_provider.dart';
import 'package:pedidos_fundacion/domain/entities/programa.dart';
import 'package:pedidos_fundacion/domain/entities/rango_edad.dart';

final groupRemoteDataSourceProvider = Provider<GroupRemoteDataSource>((ref) {
  final service = ref.watch(firestoreProvider);
  return GroupRemoteDataSource(service);
});

class GroupRemoteDataSource {
  final FirebaseFirestore _firestore;
  static const String _collection = 'groups';

  GroupRemoteDataSource(this._firestore);

  // CREATE
  Future<void> createGroup(Group group) async {
    try {
      await _firestore.collection(_collection).doc(group.id).set(group.toMap());
    } catch (e) {
      log('Error creating group', error: e);
      throw Exception('Error al crear el grupo: $e');
    }
  }

  // READ
  Future<Group?> getGroup(String groupId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(groupId).get();

      if (doc.exists && doc.data() != null) {
        return Group.fromMap(doc.data()!..['id'] = doc.id);
      }
      return null;
    } catch (e) {
      log('Error getting group', error: e);
      throw Exception('Error al obtener el grupo: $e');
    }
  }

  // READ ALL
  Future<List<Group>> getAllGroups() async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();

      return querySnapshot.docs.map((doc) {
        return Group.fromMap(doc.data()..['id'] = doc.id);
      }).toList();
    } catch (e) {
      log('Error getting all groups', error: e);
      throw Exception('Error al obtener todos los grupos: $e');
    }
  }

  // UPDATE
  Future<void> updateGroup(Group group) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(group.id)
          .update(group.toMap());
    } catch (e) {
      log('Error updating group', error: e);
      throw Exception('Error al actualizar el grupo: $e');
    }
  }

  // DELETE
  Future<void> deleteGroup(String groupId) async {
    try {
      await _firestore.collection(_collection).doc(groupId).delete();
    } catch (e) {
      log('Error deleting group', error: e);
      throw Exception('Error al eliminar el grupo: $e');
    }
  }

  Future<List<Group>> getGroupsByTutorId(String tutorId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('idTutor', isEqualTo: tutorId)
          .get();

      return querySnapshot.docs.map((doc) {
        return Group.fromMap(doc.data()..['id'] = doc.id);
      }).toList();
    } catch (e) {
      log('Error getting groups by tutor ID', error: e);
      throw Exception('Error al obtener grupos por ID de tutor: $e');
    }
  }

  Future<void> updateAgeRange(String groupId, AgeRange newAgeRange) async {
    try {
      await _firestore.collection(_collection).doc(groupId).update({
        'ageRange': {'min': newAgeRange.minAge, 'max': newAgeRange.maxAge},
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      log('Error updating age range', error: e);
      throw Exception('Error al actualizar el rango de edad: $e');
    }
  }

  Future<List<Group>> getGroupsByAge(int age) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('minAge', isLessThanOrEqualTo: age)
          .where('maxAge', isGreaterThanOrEqualTo: age)
          .get();

      return querySnapshot.docs.map((doc) {
        return Group.fromMap(doc.data()..['id'] = doc.id);
      }).toList();
    } catch (e) {
      log('Error getting groups by age: $age', error: e);
      throw Exception('Error al obtener grupos por edad: $e');
    }
  }

  Future<Group?> getFirstGroupByAge(int age) async {
    try {
      final allGroups = await getAllGroups();

      if (allGroups.isEmpty) {
        return null;
      } else {
        return allGroups.firstWhere(
          (group) =>
              age >= group.ageRange.minAge && age <= group.ageRange.maxAge,
        );
      }
    } catch (e) {
      log('Error getting first group by age: $age', error: e);
      throw Exception('Error al obtener grupo por edad: $e');
    }
  }

  Future<void> uploadGroups(List<Group> groups) async {
    try {
      // Firestore tiene un límite de 500 operaciones por batch
      const int batchLimit = 500;

      // Si hay más de 500 grupos, los dividimos en lotes
      for (int i = 0; i < groups.length; i += batchLimit) {
        final batch = _firestore.batch();
        final endIndex = (i + batchLimit > groups.length)
            ? groups.length
            : i + batchLimit;
        final groupsBatch = groups.sublist(i, endIndex);

        // Agregar cada grupo al batch
        for (final group in groupsBatch) {
          final docRef = _firestore.collection(_collection).doc(group.id);
          batch.set(docRef, group.toMap());
        }

        // Ejecutar el batch
        await batch.commit();
        log(
          'Batch ${(i ~/ batchLimit) + 1} completado: ${groupsBatch.length} grupos subidos',
        );
      }

      log('Subida completa: ${groups.length} grupos subidos exitosamente');
    } catch (e) {
      log('Error uploading groups', error: e);
      throw Exception('Error al subir los grupos: $e');
    }
  }
}
