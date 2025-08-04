import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/services/image_storage.dart';
import 'package:pedidos_fundacion/core/services/upload_image.dart';
import 'package:pedidos_fundacion/core/utils/network_utils.dart';
import 'package:pedidos_fundacion/core/utils/uuid.dart';
import 'package:pedidos_fundacion/data/datasources/encargado/local_datasource.dart';
import 'package:pedidos_fundacion/data/datasources/encargado/remote_datasource.dart';
import 'package:pedidos_fundacion/data/datasources/foto/local_datasource.dart';
import 'package:pedidos_fundacion/data/datasources/foto/remote_datasource.dart';
import 'package:pedidos_fundacion/data/preferences_usuario.dart';
import 'package:pedidos_fundacion/di/services_provider.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';
import 'package:pedidos_fundacion/domain/entities/foto.dart';
import 'package:pedidos_fundacion/domain/repositories/encargado_repository.dart';

final coordinatorRepoProvider = Provider(
  (ref) => CoordinatorRepositoryImpl(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    coordinatorRemoteDataSource: ref.watch(coordinatorDataSourceProvider),
    coordinatorLocalDatasource: ref.watch(localDataSourceProvider),
    photoLocalDataSource: ref.watch(photoLocalDataSourceProvider),
    photoRemoteDataSource: ref.watch(photoDataSourceProvider),
    preferencesUsuario: ref.watch(preferencesUsuarioProvider),
  ),
);

class CoordinatorRepositoryImpl implements CoordinatorRepository {
  final FirebaseAuth firebaseAuth;
  final CoordinatorRemoteDataSource coordinatorRemoteDataSource;
  final CoordinatorLocalDatasource coordinatorLocalDatasource;
  final PhotoLocalDataSource photoLocalDataSource;
  final PhotoRemoteDataSource photoRemoteDataSource;
  final PreferencesUsuario preferencesUsuario;

  CoordinatorRepositoryImpl({
    required this.firebaseAuth,
    required this.coordinatorRemoteDataSource,
    required this.coordinatorLocalDatasource,
    required this.photoLocalDataSource,
    required this.photoRemoteDataSource,
    required this.preferencesUsuario,
  });

  @override
  Future<bool> existsByDni(String dni) {
    try {
      return coordinatorRemoteDataSource.existsByDni(dni);
    } catch (e) {
      log('Error checking DNI: $e');
      return Future.value(false);
    }
  }

  @override
  Future<bool> existsByEmail(String email) {
    try {
      return coordinatorRemoteDataSource.existsByEmail(email);
    } catch (e) {
      log('Error checking email: $e');
      return Future.value(false);
    }
  }

  //Usamos un stream ya que primero accedemos a datos locales de la aplicacion bajo el concepto "offline first"
  @override
  Stream<Coordinator?> getCoordinator(String id) async* {
    try {
      final localCoordinator = await coordinatorLocalDatasource.getCoordinator(
        id,
      );
      if (localCoordinator != null) {
        yield localCoordinator;
      }

      final remoteCoordinator = await coordinatorRemoteDataSource
          .getCoordinator(id);
      if (remoteCoordinator != null) {
        await coordinatorLocalDatasource.update(remoteCoordinator);
        yield remoteCoordinator;
      }
    } catch (e) {
      log('Error getting coordinator: $e');
      yield null;
    }
  }

  @override
  Future<String?> registerCoordinator(Coordinator coordinator) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: coordinator.email,
        password: coordinator.password,
      );

      coordinator = coordinator.copyWith(
        id: userCredential.user?.uid,
        updateAt: DateTime.now(),
      );

      coordinatorRemoteDataSource.insert(coordinator);
      coordinatorLocalDatasource.insert(coordinator);
      log('Coordinator saved successfully: ${coordinator.id}');
      return Future.value(coordinator.id);
    } catch (e) {
      log('Error saving coordinator: $e');
      return Future.value(null);
    }
  }

  @override
  Future<Photo?> registerPhoto(File image) async {
    final urlRemote = await UploadImageRemote.saveImage(image);
    if (urlRemote != null) {
      final urlLocal = await UploadImageLocal.saveImageLocally(
        image,
        'profile_photo',
      );

      final photo = Photo(
        id: UUID.generateUUID(),
        name: 'profile_photo',
        urlRemote: urlRemote,
        urlLocal: urlLocal,
      );

      photoRemoteDataSource.insert(photo);
      photoLocalDataSource.insert(photo);

      return photo;
    }
    return null;
  }

  @override
  Future<void> updatePhotoCoordinator(
    Coordinator coordinator,
    Photo photo,
  ) async {
    try {
      final updatedCoordinator = coordinator.copyWith(idPhoto: photo.id);

      await coordinatorRemoteDataSource.updatePhotoId(updatedCoordinator);
      await coordinatorLocalDatasource.update(updatedCoordinator);
    } catch (e) {
      log('Error updating coordinator photo: $e');
      return Future.error('Failed to update coordinator photo');
    }
  }

  @override
  void updateLocationCoordinator(Coordinator coordinator) {
    try {
      coordinatorLocalDatasource.updateLocation(coordinator);
      coordinatorRemoteDataSource.updateLocation(coordinator);
    } catch (e) {
      log('Error updating coordinator photo: $e');
    }
  }

  @override
  Future<Coordinator?> login(String username, String password) async {
    try {
      final hasInternet = await NetworkUtils.hasRealInternet();

      if (hasInternet) {
        return loginInternet(username, password);
      } else {
        return loginNoInternet(username, password);
      }
    } catch (e) {
      log('Error loging coordinator: $e');
    }
    return null;
  }

  Future<Coordinator?> loginInternet(String username, String password) async {
    final email = await coordinatorRemoteDataSource.getCoordinatorEmail(
      username,
    );

    if (email != null && email.isNotEmpty) {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;

      if (firebaseUser != null) {
        final user = await coordinatorRemoteDataSource.getCoordinator(
          firebaseUser.uid,
        );

        if (user != null) preferencesUsuario.savePreferences(user);

        return user;
      }
    }
    return null;
  }

  Future<Coordinator?> loginNoInternet(String username, String password) async {
    return await preferencesUsuario.checkLogin(username, password);
  }

  @override
  void updateActiveCoordinator(Coordinator coordinator) {
    try {
      coordinatorLocalDatasource.updateActive(coordinator);
      coordinatorRemoteDataSource.updateActive(coordinator);
    } catch (e) {
      log('Error updating coordinator photo: $e');
    }
  }
}
