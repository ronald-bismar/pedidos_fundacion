import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/encargado_repository_impl.dart';
import 'package:pedidos_fundacion/data/group_repository_impl.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';
import 'package:pedidos_fundacion/domain/entities/programa.dart';

final updateLocationCoordinatorProvider =
    Provider<void Function(Coordinator, Group?)>((ref) {
      final coordinatorRepository = ref.watch(coordinatorRepoProvider);
      final groupRepository = ref.watch(groupRepoProvider);

      return (Coordinator coordinator, Group? group) {
        coordinatorRepository.updateLocationCoordinator(coordinator);
        if (group != null) groupRepository.updateGroup(group);
      };
    });
