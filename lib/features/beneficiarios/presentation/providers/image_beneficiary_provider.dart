import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/beneficiary_repository_impl.dart';
import 'package:pedidos_fundacion/domain/repositories/beneficiary_repository.dart';

final imageBeneficiaryProvider =
    StateNotifierProvider.family<
      ImageBeneficiaryProfileNotifier,
      ({String? urlPhoto, bool isLocal}),
      String
    >((ref, idPhoto) {
      return ImageBeneficiaryProfileNotifier(
        ref.watch(beneficiaryRepoProvider),
        idPhoto,
      );
    });

class ImageBeneficiaryProfileNotifier
    extends StateNotifier<({String? urlPhoto, bool isLocal})> {
  final BeneficiaryRepository _repository;

  ImageBeneficiaryProfileNotifier(this._repository, String idPhoto)
    : super((urlPhoto: null, isLocal: false)) {
    _loadPhoto(idPhoto);
  }

  Future<void> _loadPhoto(String idPhoto) async {
    state = await _repository.getPhoto(idPhoto);
  }
}
