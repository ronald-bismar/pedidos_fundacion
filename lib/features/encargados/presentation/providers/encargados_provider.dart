import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/encargado_repository_impl.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';

final coordinatorsProvider = FutureProvider<List<Coordinator>>((ref) {
  final coordinatorRepository = ref.watch(coordinatorRepoProvider);
  return coordinatorRepository.getCoordinators();
});
