import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/beneficiary_repository_impl.dart';
import 'package:pedidos_fundacion/domain/repositories/beneficiary_repository.dart';

final getCodeBeneficiaryUseCaseProvider = Provider(
  (ref) => GetCodeBeneficiaryUseCase(ref.watch(beneficiaryRepoProvider)),
);

class GetCodeBeneficiaryUseCase {
  BeneficiaryRepository beneficiaryRepository;

  GetCodeBeneficiaryUseCase(this.beneficiaryRepository);

  Future<String?> call() async {
    final lastCodeCorrelative = await beneficiaryRepository
        .getLastCorrelativeCode();
    if (lastCodeCorrelative == null) {
      return null;
    }
    final newCorrelative = lastCodeCorrelative + 1;
    final newCodeForUser = 'BO$newCorrelative';
    return newCodeForUser;
  }
}
