import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/beneficiary_repository_impl.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';

final updateGroupBeneficiaryProvider =
    Provider<void Function(Beneficiary, String)>((ref) {
      final beneficiaryRepository = ref.watch(beneficiaryRepoProvider);

      return (Beneficiary beneficiary, String idGroup) {
        beneficiaryRepository.updateGroup(idGroup, beneficiary);
      };
    });
