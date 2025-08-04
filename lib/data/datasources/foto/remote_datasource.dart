import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/di/services_provider.dart';
import 'package:pedidos_fundacion/domain/entities/foto.dart';

final photoDataSourceProvider = Provider<PhotoRemoteDataSource>((ref) {
  final service = ref.watch(firestoreProvider);
  return PhotoRemoteDataSource(service);
});

class PhotoRemoteDataSource {
  final FirebaseFirestore service;
  static const String _collection = 'photos';

  PhotoRemoteDataSource(this.service);

  Future<void> insert(Photo photo) async {
    try {
      await service.collection(_collection).doc(photo.id).set(photo.toMap());
    } catch (e) {
      throw Exception('Error creating photo: $e');
    }
  }

  Future<Photo?> getPhoto(String photoId) async {
    try {
      final doc = await service.collection(_collection).doc(photoId).get();

      if (doc.exists && doc.data() != null) {
        return Photo.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting photo by ID: $e');
    }
  }

  Future<List<Photo>> getAllPhotos() async {
    try {
      final querySnapshot = await service.collection(_collection).get();

      return querySnapshot.docs.map((doc) {
        return Photo.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error getting all photos: $e');
    }
  }

  Future<void> updatePhoto(Photo photo) async {
    try {
      await service
          .collection(_collection)
          .doc(photo.id)
          .update(photo.toMap());
    } catch (e) {
      throw Exception('Error updating photo: $e');
    }
  }

  Future<void> updatePhotoUrl(
    String photoId,
    String urlRemote,
    String urlLocal,
  ) async {
    try {
      await service.collection(_collection).doc(photoId).update({
        'urlRemote': urlRemote,
        'urlLocal': urlLocal,
      });
    } catch (e) {
      throw Exception('Error updating photo URL: $e');
    }
  }

  Future<void> deletePhoto(String photoId) async {
    try {
      await service.collection(_collection).doc(photoId).delete();
    } catch (e) {
      throw Exception('Error deleting photo: $e');
    }
  }
}
