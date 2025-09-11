// lib/features/groups/presentation/providers/group_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/repositories/group_repository.dart';
import '../../data/datasources/group_remote_datasource.dart';
import '../../data/repositories_impl/group_repository_impl.dart';
import '../../domain/usecases/add_group_usecase.dart';
import '../../domain/usecases/get_groups_usecase.dart';
import '../../domain/usecases/delete_group_usecase.dart';
import '../../domain/usecases/update_group_usecase.dart';
import '../../domain/usecases/restore_group_usecase.dart';
import '../../domain/usecases/block_group_usecase.dart';
import '../notifiers/group_notifier.dart';

// -----------------------------------------------------------
// Providers de la capa de datos
// -----------------------------------------------------------

final groupRemoteDataSourceProvider = Provider((ref) => GroupRemoteDataSource());

// -----------------------------------------------------------
// Provider del Repositorio
// -----------------------------------------------------------

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  final remoteDataSource = ref.read(groupRemoteDataSourceProvider);
  return GroupRepositoryImpl(remoteDataSource: remoteDataSource);
});
// -----------------------------------------------------------
// Providers de los Casos de Uso
// -----------------------------------------------------------

final getGroupsUseCaseProvider = Provider((ref) {
  final repo = ref.read(groupRepositoryProvider);
  return GetGroupsUseCase(repo);
});

final addGroupUseCaseProvider = Provider((ref) {
  final repo = ref.read(groupRepositoryProvider);
  return AddGroupUseCase(repo);
});

final updateGroupUseCaseProvider = Provider((ref) {
  final repo = ref.read(groupRepositoryProvider);
  return UpdateGroupUseCase(repo);
});

final deleteGroupUseCaseProvider = Provider((ref) {
  final repo = ref.read(groupRepositoryProvider);
  return DeleteGroupUseCase(repo);
});

final restoreGroupUseCaseProvider = Provider((ref) {
  final repo = ref.read(groupRepositoryProvider);
  return RestoreGroupUseCase(repo);
});

final blockGroupUseCaseProvider = Provider((ref) {
  final repo = ref.read(groupRepositoryProvider);
  return BlockGroupUseCase(repo);
});

// -----------------------------------------------------------
// Provider del Notifier (La capa de Presentación)
// -----------------------------------------------------------

final groupsNotifierProvider =
    AsyncNotifierProvider<GroupsNotifier, List<GroupEntity>>(() {
  return GroupsNotifier();
});