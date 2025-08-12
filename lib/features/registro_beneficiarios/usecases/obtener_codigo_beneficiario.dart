import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/beneficiary_repository_impl.dart';
import 'package:pedidos_fundacion/domain/repositories/beneficiary_repository.dart';

final getCodeBeneficiaryUseCaseProvider = Provider(
  (ref) => GetCodeBeneficiaryUseCase(ref.watch(beneficiaryRepoProvider)),
);

final getCodeBeneficiaryProvider = FutureProvider<String?>((ref) async {
  final useCase = ref.watch(getCodeBeneficiaryUseCaseProvider);
  return await useCase();
});

class GetCodeBeneficiaryUseCase {
  BeneficiaryRepository beneficiaryRepository;

  GetCodeBeneficiaryUseCase(this.beneficiaryRepository);

  Future<String?> call() async {
    int? lastCodeCorrelative = await beneficiaryRepository
        .getLastCorrelativeCode();
    if (lastCodeCorrelative == null) {
      return null;
    }

    lastCodeCorrelative = lastCodeCorrelative + 1;

    /**Guardamos tambien el ultimo correlativo para que otro usuario tenga
    el numero actualizado **/

    beneficiaryRepository.saveLastCorrelativeCode(lastCodeCorrelative);

    //La forma de codigo el numero de digitos puede variar entre empresas
    final newCorrelative = lastCodeCorrelative.toString().padLeft(9, '0');
    final newCodeForUser = 'BO$newCorrelative';
    return newCodeForUser;
  }
}
