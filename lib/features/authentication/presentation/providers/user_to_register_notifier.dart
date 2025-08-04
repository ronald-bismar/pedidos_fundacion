import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/encargado_repository_impl.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';

final coordinatorStreamProvider = StreamProvider.family<Coordinator?, String>((
  ref,
  id,
) {
  final coordinatorRepository = ref.watch(coordinatorRepoProvider);
  return coordinatorRepository.getCoordinator(id);
});