import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/mappers/encargado_mapper.dart';
import 'package:pedidos_fundacion/di/services_provider.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';
import 'package:pedidos_fundacion/domain/repositories/encargado_repository.dart';

final coordinatorRepoProvider = Provider(
  (ref) => CoordinatorRepositoryImpl(
    firestoreService: ref.watch(firestoreProvider),
    firebaseAuth: ref.watch(firebaseAuthProvider),
  ),
);

class CoordinatorRepositoryImpl implements CoordinatorRepository {
  final FirebaseFirestore firestoreService;
  final FirebaseAuth firebaseAuth;

  CoordinatorRepositoryImpl({
    required this.firestoreService,
    required this.firebaseAuth,
  });

  @override
  Future<bool> existsByDni(String dni) {
    final snapshot = firestoreService
        .collection('coordinators')
        .where('dni', isEqualTo: dni)
        .get();
    return snapshot.then((value) => value.docs.isNotEmpty);
  }

  @override
  Future<bool> existsByEmail(String email) {
    final snapshot = firestoreService
        .collection('coordinators')
        .where('email', isEqualTo: email)
        .get();
    return snapshot.then((value) => value.docs.isNotEmpty);
  }

  @override
  Future<Coordinator?> getCoordinator(String id) {
    return firestoreService.collection('coordinators').doc(id).get().then((
      snapshot,
    ) {
      if (snapshot.exists) {
        return CoordinatorMapper.fromJson(snapshot.data()!);
      }
      return null;
    });
  }

  @override
  Future<void> saveCoordinator(Coordinator coordinator) {
    return firestoreService
        .collection('coordinators')
        .doc(coordinator.id)
        .set(CoordinatorMapper.toJson(coordinator));
  }
}
