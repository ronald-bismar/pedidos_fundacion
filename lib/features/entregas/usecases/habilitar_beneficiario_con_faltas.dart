import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/results/result_global.dart';

final enableBeneficiaryWithNotAsistedUseCaseProvider = Provider(
  (ref) => EnableBeneficiaryWithNotAsistedUseCase(),
);

class EnableBeneficiaryWithNotAsistedUseCase {
  EnableBeneficiaryWithNotAsistedUseCase();

  Future<Result> call() async {
    return Result.success('Asistencia registrada con éxito');
  }
}
