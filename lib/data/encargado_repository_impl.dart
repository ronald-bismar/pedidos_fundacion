import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/mappers/encargado_mapper.dart';
import 'package:pedidos_fundacion/data/preferences_usuario.dart';
import 'package:pedidos_fundacion/di/services_provider.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';
import 'package:pedidos_fundacion/domain/repositories/encargado_repository.dart';

final coordinatorRepoProvider = Provider(
  (ref) => CoordinatorRepositoryImpl(
    firestoreService: ref.watch(firestoreProvider),
    firebaseAuth: ref.watch(firebaseAuthProvider),
    preferencesUsuario: ref.watch(preferencesUsuarioProvider),
  ),
);

class CoordinatorRepositoryImpl implements CoordinatorRepository {
  final FirebaseFirestore firestoreService;
  final FirebaseAuth firebaseAuth;
  final PreferencesUsuario preferencesUsuario;

  CoordinatorRepositoryImpl({
    required this.firestoreService,
    required this.firebaseAuth,
    required this.preferencesUsuario,
  });

  @override
  Future<bool> existsByDni(String dni) {
    try {
      final snapshot = firestoreService
          .collection('coordinators')
          .where('dni', isEqualTo: dni)
          .get();
      return snapshot.then((value) => value.docs.isNotEmpty);
    } catch (e) {
      log('Error checking DNI: $e');
      return Future.value(false);
    }
  }

  @override
  Future<bool> existsByEmail(String email) {
    try {
      final snapshot = firestoreService
          .collection('coordinators')
          .where('email', isEqualTo: email)
          .get();
      return snapshot.then((value) => value.docs.isNotEmpty);
    } catch (e) {
      log('Error checking email: $e');
      return Future.value(false);
    }
  }

  @override
  Future<Coordinator?> getCoordinator(String id) {
    try {
      return firestoreService.collection('coordinators').doc(id).get().then((
        snapshot,
      ) {
        if (snapshot.exists) {
          return CoordinatorMapper.fromJson(snapshot.data()!);
        }
        return null;
      });
    } catch (e) {
      log('Error getting coordinator: $e');
      return Future.value(null);
    }
  }

  @override
  Future<bool> saveCoordinator(Coordinator coordinator) {
    try {
      firebaseAuth
          .createUserWithEmailAndPassword(
            email: coordinator.email,
            password: coordinator.password,
          )
          .then((userCredential) {
            log('Usuario creado exitosamente: ${userCredential.user?.uid}');

            firestoreService
                .collection('coordinators')
                .doc(coordinator.id)
                .set(CoordinatorMapper.toJson(coordinator));

            preferencesUsuario.savePreferencesCoordinator(coordinator);
          });
      return Future.value(true);
    } catch (e) {
      log('Error saving coordinator: $e');
      return Future.value(false);
    }
  }
}
