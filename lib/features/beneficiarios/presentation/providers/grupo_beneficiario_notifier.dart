import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/beneficiary_repository_impl.dart';
import 'package:pedidos_fundacion/data/group_repository_impl.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';
import 'package:pedidos_fundacion/domain/entities/programa.dart';

class BeneficiaryWithGroup {
  final Beneficiary? beneficiary;
  final Group? group;
  final List<Group> groups;

  BeneficiaryWithGroup({
    required this.beneficiary,
    required this.group,
    required this.groups,
  });
}

final beneficiaryWithGroupProvider =
    FutureProvider.family<BeneficiaryWithGroup, String>((
      ref,
      beneficiaryId,
    ) async {
      final beneficiaryRepository = ref.watch(beneficiaryRepoProvider);
      final groupRepository = ref.watch(groupRepoProvider);

      // Obtener beneficiario como Future (stream puede ser convertido a Future usando first)
      final beneficiaryStream = beneficiaryRepository.getBeneficiary(
        beneficiaryId,
      );
      final beneficiary = await beneficiaryStream.firstWhere(
        (b) => true,
        orElse: () => null,
      );

      if (beneficiary == null) {
        // No existe beneficiario, retornamos con grupo null
        return BeneficiaryWithGroup(beneficiary: null, group: null, groups: []);
      }

      final List<Group> groups = await groupRepository.getAllGroups();

      final group = groups
          .where((group) => group.id == beneficiary.idGroup)
          .firstOrNull;

      return BeneficiaryWithGroup(
        beneficiary: beneficiary,
        group: group,
        groups: groups,
      );
    });
