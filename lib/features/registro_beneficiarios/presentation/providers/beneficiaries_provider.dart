import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/beneficiary_repository_impl.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';

final beneficiariesStreamProvider =
    StreamProvider.family<List<Beneficiary>, String>((ref, idGroup) {
      final beneficiaryRepository = ref.watch(beneficiaryRepoProvider);
      return beneficiaryRepository.getBeneficiariesByGroup(idGroup);
    });
