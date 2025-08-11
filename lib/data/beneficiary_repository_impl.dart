import 'dart:developer';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/services/image_storage.dart';
import 'package:pedidos_fundacion/core/services/upload_image.dart';
import 'package:pedidos_fundacion/core/utils/network_utils.dart';
import 'package:pedidos_fundacion/core/utils/uuid.dart';
import 'package:pedidos_fundacion/data/datasources/beneficiario/local_datasource.dart';
import 'package:pedidos_fundacion/data/datasources/beneficiario/remote_datasource.dart';
import 'package:pedidos_fundacion/data/datasources/foto/local_datasource.dart';
import 'package:pedidos_fundacion/data/datasources/foto/remote_datasource.dart';
import 'package:pedidos_fundacion/data/preferences_usuario.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';
import 'package:pedidos_fundacion/domain/entities/foto.dart';
import 'package:pedidos_fundacion/domain/repositories/beneficiary_repository.dart';

final beneficiaryRepoProvider = Provider(
  (ref) => BeneficiaryRepositoryImpl(
    beneficiaryRemoteDataSource: ref.watch(beneficiaryRemoteDataSourceProvider),
    beneficiaryLocalDatasource: ref.watch(beneficiaryLocalDataSourceProvider),
    photoLocalDataSource: ref.watch(photoLocalDataSourceProvider),
    photoRemoteDataSource: ref.watch(photoDataSourceProvider),
    preferencesUsuario: ref.watch(preferencesUsuarioProvider),
  ),
);

class BeneficiaryRepositoryImpl extends BeneficiaryRepository {
  final BeneficiaryRemoteDataSource beneficiaryRemoteDataSource;
  final BeneficiaryLocalDataSource beneficiaryLocalDatasource;
  final PhotoLocalDataSource photoLocalDataSource;
  final PhotoRemoteDataSource photoRemoteDataSource;
  final PreferencesUsuario preferencesUsuario;

  BeneficiaryRepositoryImpl({
    required this.beneficiaryRemoteDataSource,
    required this.beneficiaryLocalDatasource,
    required this.photoLocalDataSource,
    required this.photoRemoteDataSource,
    required this.preferencesUsuario,
  });
  @override
  Future<bool> existsByDni(String dni) async {
    try {
      final existDni = await beneficiaryLocalDatasource.existByDni(dni);

      if (existDni) {
        return true;
      }

      return await beneficiaryRemoteDataSource.existsByDni(dni);
    } catch (e) {
      log('Error checking DNI: $e');
      return false;
    }
  }

  @override
  Stream<Beneficiary?> getBeneficiary(String id) async* {
    try {
      final localBeneficiary = await beneficiaryLocalDatasource.getBeneficiary(
        id,
      );
      if (localBeneficiary != null) {
        log('Mandando beneficiario desde bd local...');
        yield localBeneficiary;
      }

      final remoteBeneficiary = await beneficiaryRemoteDataSource
          .getBeneficiary(id);
      if (remoteBeneficiary != null) {
        log('Mandando beneficiario desde bd remota...');
        await beneficiaryLocalDatasource.update(remoteBeneficiary);
        yield remoteBeneficiary;
      }
    } catch (e) {
      log('Error getting beneficiary: $e');
      yield null;
    }
  }

  @override
  Future<({bool isLocal, String? urlPhoto})> getPhoto(
    Beneficiary beneficiary,
  ) async {
    try {
      final hasInternet = await NetworkUtils.hasRealInternet();
      if (hasInternet) {
        final Photo? photo = await photoRemoteDataSource.getPhoto(
          beneficiary.idPhoto,
        );
        if (photo != null) {
          log('url photo: local: ${photo.urlLocal} remote: ${photo.urlRemote}');
          return (urlPhoto: photo.urlRemote, isLocal: false);
        } else {
          return (urlPhoto: await getUrlLocalPhoto(beneficiary), isLocal: true);
        }
      } else {
        return (urlPhoto: await getUrlLocalPhoto(beneficiary), isLocal: true);
      }
    } catch (e) {
      log('Error getting photo of beneficiary: $e');
      return (urlPhoto: null, isLocal: false);
    }
  }

  @override
  Future<String?> registerBeneficiary(Beneficiary beneficiary) async {
    try {
      beneficiary = beneficiary.copyWith(
        id: UUID.generateUUID(),
        updateAt: DateTime.now(),
      );

      beneficiaryRemoteDataSource.insert(beneficiary);
      beneficiaryLocalDatasource.insert(beneficiary);
      log('Beneficiary saved successfully: ${beneficiary.id}');
      return Future.value(beneficiary.id);
    } catch (e) {
      log('Error saving coordinator: $e');
      return Future.value(null);
    }
  }

  @override
  Future<Photo?> registerPhoto(File image) async {
    final urlRemote = await UploadImageRemote.saveImage(image);
    if (urlRemote != null) {
      final urlLocal = await UploadImageLocal.saveImageLocally(
        image,
        'profile_photo_beneficiary',
      );

      final photo = Photo(
        id: UUID.generateUUID(),
        name: 'profile_photo_beneficiary',
        urlRemote: urlRemote,
        urlLocal: urlLocal,
      );

      photoRemoteDataSource.insert(photo);
      photoLocalDataSource.insert(photo);

      return photo;
    }
    return null;
  }

  @override
  void updateActiveBeneficiary(Beneficiary beneficiary) {
    try {
      beneficiaryLocalDatasource.updateActive(beneficiary);
      beneficiaryRemoteDataSource.updateActive(beneficiary);
    } catch (e) {
      log('Error updating beneficiary photo: $e');
    }
  }

  @override
  Future<void> updatePhotoBeneficiary(
    Beneficiary beneficiary,
    Photo photo,
  ) async {
    try {
      final updatedBeneficiary = beneficiary.copyWith(idPhoto: photo.id);

      await beneficiaryRemoteDataSource.updatePhotoId(updatedBeneficiary);
      await beneficiaryLocalDatasource.update(updatedBeneficiary);
    } catch (e) {
      log('Error updating coordinator photo: $e');
      return Future.error('Failed to update coordinator photo');
    }
  }

  Future<String?> getUrlLocalPhoto(Beneficiary beneficiary) async {
    final Photo? photo = await photoLocalDataSource.getPhoto(
      beneficiary.idPhoto,
    );

    if (photo != null) {
      return photo.urlLocal;
    } else {
      return null;
    }
  }

  @override
  Future<int?> getLastCorrelativeCode() async {
    try {
      return await beneficiaryRemoteDataSource.getLastCorrelative();
    } catch (e) {
      log('Error getting las correlative: $e');
    }
    return null;
  }

  @override
  Future<void> saveLastCorrelativeCode(int codeCorrelative) async {
    try {
      await beneficiaryRemoteDataSource.saveLastCorrelative(codeCorrelative);
    } catch (e) {
      log('Error saving las correlative: $e');
    }
  }

  @override
  Future<bool> updateLocationAndPhone(Beneficiary beneficiary) async {
    try {
      //Solo lo lanzamos al guardado remoto sin esperar respuesta
      beneficiaryRemoteDataSource.updateLocationAndPhone(beneficiary);

      return await beneficiaryLocalDatasource.updateLocationAndPhone(
        beneficiary.id,
        beneficiary.location,
        beneficiary.phone,
      );
    } catch (e) {
      log('Error saving las correlative: $e');
      return false;
    }
  }

  void updateGroup(String idGroup, Beneficiary beneficiary) {
    try {
      beneficiaryLocalDatasource.updateGroup(beneficiary.id, idGroup);
      beneficiaryRemoteDataSource.updateGroup(beneficiary, idGroup);
    } catch (e) {
      log('Error updating group of beneficiary: $e');
    }
  }

  @override
  Stream<List<Beneficiary>> getBeneficiariesByGroup(String idGroup) async* {
    try {
      final beneficiariesLocal = await beneficiaryLocalDatasource.listByGroup(
        idGroup,
      );

      yield beneficiariesLocal;

      final beneficiariesRemote = await beneficiaryRemoteDataSource.getByGroup(
        idGroup,
      );
      if (beneficiariesRemote.isNotEmpty) {
        await beneficiaryLocalDatasource.insertOrUpdate(beneficiariesRemote);
        yield beneficiariesRemote;
      }
    } catch (e) {
      log('Error getting coordinator: $e');
      yield [];
    }
  }
}
