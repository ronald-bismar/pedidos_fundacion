import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/encargado_repository_impl.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';

final updateLocationCoordinatorProvider = Provider<void Function(Coordinator)>((
  ref,
) {
  final coordinatorRepository = ref.watch(coordinatorRepoProvider);

  return (Coordinator coordinator) {
    coordinatorRepository.updateLocationCoordinator(coordinator);
  };
});
