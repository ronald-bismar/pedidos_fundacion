import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/results/result_global.dart';

final notifyNewOrderToAdministratorRPUseCaseProvider = Provider(
  (ref) => NotifyNewOrderToAdministratorRPUseCase(),
);

class NotifyNewOrderToAdministratorRPUseCase {
  NotifyNewOrderToAdministratorRPUseCase();

  Future<Result> call() async {
    return Result.success('Notificacion enviada con exito');
  }
}
