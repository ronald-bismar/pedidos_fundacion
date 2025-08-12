import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/encargado_repository_impl.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';

final imageUserProfileProvider =
    StateNotifierProvider<
      ImageUserProfileNotifier,
      ({String name, String? urlPhoto, bool isLocal})
    >((ref) => ImageUserProfileNotifier(ref.watch(coordinatorRepoProvider)));

class ImageUserProfileNotifier
    extends StateNotifier<({String name, String? urlPhoto, bool isLocal})> {
  final CoordinatorRepositoryImpl _repository;

  ImageUserProfileNotifier(this._repository)
    : super((name: '', urlPhoto: null, isLocal: false));

  Future<void> loadNameAndPhoto(Coordinator coordinator) async {
    state = await _repository.getNameAndPhoto(coordinator);
  }
}
