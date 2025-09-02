import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/results/result_global.dart';

final generateDeliveriesUseCaseProvider = Provider(
  (ref) => GenerateDeliveriesUseCase(),
);

class GenerateDeliveriesUseCase {
  GenerateDeliveriesUseCase();

  Future<Result> call() async {
    return Result.success('Entregas generadas con exito');
  }
}
