import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/beneficiary_repository_impl.dart';
import 'package:pedidos_fundacion/data/datasources/grupo/local_datasources.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';
import 'package:pedidos_fundacion/domain/entities/programa.dart';

final beneficiaryStreamProvider = StreamProvider.family<Beneficiary?, String>((
  ref,
  id,
) {
  final beneficiaryRepository = ref.watch(beneficiaryRepoProvider);
  return beneficiaryRepository.getBeneficiary(id);
});

final beneficiaryGroupAssignedStreamProvider =
    FutureProvider.family<Group?, String>((ref, id) {
      final localDataSource = ref.watch(groupLocalDataSourceProvider);
      return localDataSource.getGroup(id);
    });
