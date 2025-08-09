import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/datasources/grupo/local_datasources.dart';
import 'package:pedidos_fundacion/data/datasources/grupo/remote_datasources.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';
import 'package:pedidos_fundacion/domain/entities/programa.dart';

final assignGroupUseCaseProvider = Provider(
  (ref) => AssignGroupUseCase(
    ref.watch(groupLocalDataSourceProvider),
    ref.watch(groupRemoteDataSourceProvider),
  ),
);

//Offline first: Consultamos siempre a la base de datos local y despues a la base de datos remota
class AssignGroupUseCase {
  GroupLocalDataSource groupLocalDataSource;
  GroupRemoteDataSource groupRemoteDataSource;

  AssignGroupUseCase(this.groupLocalDataSource, this.groupRemoteDataSource);

  Future<Beneficiary> call(Beneficiary beneficiary) async {
    Group? group = await groupLocalDataSource.getGroupByAge(beneficiary.age);

    if (group != null) {
      return beneficiary.copyWith(idGroup: group.id);
    } else {
      group = await groupRemoteDataSource.getFirstGroupByAge(beneficiary.age);
      if (group != null) {
        return beneficiary.copyWith(idGroup: group.id);
      }
    }
    return beneficiary;
  }
}
