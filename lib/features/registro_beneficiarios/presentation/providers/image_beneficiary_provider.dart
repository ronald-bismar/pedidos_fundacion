import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/beneficiary_repository_impl.dart';
import 'package:pedidos_fundacion/domain/repositories/beneficiary_repository.dart';

final imageBeneficiaryProvider =
    StateNotifierProvider<
      ImageBeneficiaryProfileNotifier,
      ({String? urlPhoto, bool isLocal})
    >(
      (ref) =>
          ImageBeneficiaryProfileNotifier(ref.watch(beneficiaryRepoProvider)),
    );

class ImageBeneficiaryProfileNotifier
    extends StateNotifier<({String? urlPhoto, bool isLocal})> {
  final BeneficiaryRepository _repository;

  ImageBeneficiaryProfileNotifier(this._repository)
    : super((urlPhoto: null, isLocal: false));

  Future<void> loadPhoto(String idPhoto) async {
    state = await _repository.getPhoto(idPhoto);
  }
}
