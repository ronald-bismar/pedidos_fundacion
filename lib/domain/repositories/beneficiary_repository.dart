import 'dart:io';

import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';
import 'package:pedidos_fundacion/domain/entities/foto.dart';

abstract class BeneficiaryRepository {
  Future<String?> registerBeneficiary(Beneficiary beneficiary);
  Future<bool> existsByDni(String dni);
  Stream<Beneficiary?> getBeneficiary(String id);
  Future<Photo?> registerPhoto(File image);
  Future<void> updatePhotoBeneficiary(Beneficiary beneficiary, Photo photo);
  void updateActiveBeneficiary(Beneficiary beneficiary);
  Future<({bool isLocal, String? urlPhoto})> getPhoto(Beneficiary beneficiary);
  Future<int?> getLastCorrelativeCode();
  Future<void> saveLastCorrelativeCode(int codeCorrelative);
  Future<bool> updateLocationAndPhone(Beneficiary beneficiary);
}
