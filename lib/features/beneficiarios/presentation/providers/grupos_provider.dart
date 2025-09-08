import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/group_repository_impl.dart';
import 'package:pedidos_fundacion/domain/entities/programa.dart';

final groupsProvider = FutureProvider<List<Group>>((ref) {
  final groupRepository = ref.watch(groupRepoProvider);
  return groupRepository.getAllGroups();
});
