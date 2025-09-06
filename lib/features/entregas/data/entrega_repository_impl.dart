import 'dart:developer';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/results/result_global.dart';
import 'package:pedidos_fundacion/core/services/image_storage.dart';
import 'package:pedidos_fundacion/core/services/upload_image.dart';
import 'package:pedidos_fundacion/core/utils/network_utils.dart';
import 'package:pedidos_fundacion/core/utils/uuid.dart';
import 'package:pedidos_fundacion/data/beneficiary_repository_impl.dart';
import 'package:pedidos_fundacion/data/datasources/foto/local_datasource.dart';
import 'package:pedidos_fundacion/data/datasources/foto/remote_datasource.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';
import 'package:pedidos_fundacion/domain/entities/foto.dart';
import 'package:pedidos_fundacion/domain/entities/programa.dart';
import 'package:pedidos_fundacion/domain/repositories/beneficiary_repository.dart';
import 'package:pedidos_fundacion/features/entregas/data/datasources/ayuda_economica/local_datasource.dart';
import 'package:pedidos_fundacion/features/entregas/data/datasources/ayuda_economica/remote_datasource.dart';
import 'package:pedidos_fundacion/features/entregas/data/datasources/beneficio/local_datasource.dart';
import 'package:pedidos_fundacion/features/entregas/data/datasources/beneficio/remote_datasource.dart';
import 'package:pedidos_fundacion/features/entregas/data/datasources/entrega/local_datasource.dart';
import 'package:pedidos_fundacion/features/entregas/data/datasources/entrega/remote_datasource.dart';
import 'package:pedidos_fundacion/features/entregas/data/datasources/entrega_beneficiario/local_datasource.dart';
import 'package:pedidos_fundacion/features/entregas/data/datasources/entrega_beneficiario/remote_datasource.dart';
import 'package:pedidos_fundacion/features/entregas/data/datasources/producto_beneficiario/local_datasource.dart';
import 'package:pedidos_fundacion/features/entregas/data/datasources/producto_beneficiario/remote_datasource.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/ayuda_economica.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/beneficio.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/entrega.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/entrega_beneficiario.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/producto_beneficiario.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/tipos_de_entregas.dart';
import 'package:pedidos_fundacion/features/entregas/domain/repositories/entrega_repository.dart';
import 'package:pedidos_fundacion/features/orders/domain/entities/order_entity.dart';
import 'package:pedidos_fundacion/toDataDynamic/estados_entrega.dart';
import 'package:pedidos_fundacion/toDataDynamic/nombre_fundacion.dart';

final entregaRepoProvider = Provider(
  (ref) => EntregaRepositoryImpl(
    financialAidLocalDataSource: ref.watch(financialAidLocalDataSourceProvider),
    financialAidRemoteDataSource: ref.watch(
      financialAidRemoteDataSourceProvider,
    ),
    benefitLocalDataSource: ref.watch(benefitLocalDataSourceProvider),
    benefitRemoteDataSource: ref.watch(benefitRemoteDataSourceProvider),
    deliveryBeneficiaryLocalDataSource: ref.watch(
      deliveryBeneficiaryLocalDataSourceProvider,
    ),
    deliveryBeneficiaryRemoteDataSource: ref.watch(
      deliveryBeneficiaryRemoteDataSourceProvider,
    ),
    deliveryLocalDataSource: ref.watch(deliveryLocalDataSourceProvider),
    deliveryRemoteDataSource: ref.watch(deliveryRemoteDataSourceProvider),
    productBeneficiaryLocalDataSource: ref.watch(
      productBeneficiaryLocalDataSourceProvider,
    ),
    productBeneficiaryRemoteDataSource: ref.watch(
      productBeneficiaryRemoteDataSourceProvider,
    ),
    beneficiaryRepository: ref.watch(beneficiaryRepoProvider),
    photoLocalDataSource: ref.watch(photoLocalDataSourceProvider),
    photoRemoteDataSource: ref.watch(photoRemoteDataSourceProvider),
  ),
);

class EntregaRepositoryImpl extends EntregaRepository {
  FinancialAidLocalDataSource financialAidLocalDataSource;
  FinancialAidRemoteDataSource financialAidRemoteDataSource;
  BenefitLocalDataSource benefitLocalDataSource;
  BenefitRemoteDataSource benefitRemoteDataSource;
  DeliveryBeneficiaryLocalDataSource deliveryBeneficiaryLocalDataSource;
  DeliveryBeneficiaryRemoteDataSource deliveryBeneficiaryRemoteDataSource;
  DeliveryLocalDataSource deliveryLocalDataSource;
  DeliveryRemoteDataSource deliveryRemoteDataSource;
  ProductBeneficiaryLocalDataSource productBeneficiaryLocalDataSource;
  ProductBeneficiaryRemoteDataSource productBeneficiaryRemoteDataSource;
  BeneficiaryRepository beneficiaryRepository;
  PhotoLocalDataSource photoLocalDataSource;
  PhotoRemoteDataSource photoRemoteDataSource;

  EntregaRepositoryImpl({
    required this.financialAidLocalDataSource,
    required this.financialAidRemoteDataSource,
    required this.benefitLocalDataSource,
    required this.benefitRemoteDataSource,
    required this.deliveryBeneficiaryLocalDataSource,
    required this.deliveryBeneficiaryRemoteDataSource,
    required this.deliveryLocalDataSource,
    required this.deliveryRemoteDataSource,
    required this.productBeneficiaryLocalDataSource,
    required this.productBeneficiaryRemoteDataSource,
    required this.beneficiaryRepository,
    required this.photoLocalDataSource,
    required this.photoRemoteDataSource,
  });

  @override
  Stream<List<Delivery>> getDeliveriesByGroups() async* {
    try {
      final localDeliveries = await deliveryLocalDataSource.getAll();

      if (localDeliveries.isNotEmpty) {
        yield localDeliveries;
      }
      final remoteDeliveries = await deliveryRemoteDataSource.getAll();
      if (remoteDeliveries.isNotEmpty) {
        await deliveryLocalDataSource.insertOrUpdate(remoteDeliveries);
        yield remoteDeliveries;
      }
      yield [];
    } catch (e) {
      log('Error getting deliveries by groups: $e');
      yield [];
    }
  }

  @override
  List<String> getTypesOfDeliveries() {
    try {
      return TypesOfDeliveries.values;
    } catch (e) {
      log('Error getting types of deliveries: $e');
      return [];
    }
  }

  @override
  Stream<List<Order>> getOrdersForDelivery() async* {
    try {
      //TODO implement
      yield [];
    } catch (e) {
      log('Error getting orders for delivery: $e');
      yield [];
    }
  }

  @override
  Future<Result> generarEntregasParaPedidosDeCanastas(
    Delivery baseDelivery,
    List<Order> orders,
    List<Benefit> benefits,
  ) async {
    try {
      List<Delivery> deliveries = [];
      List<DeliveryBeneficiary> deliveryBeneficiaries = [];
      List<Benefit> benefitsByDelivery = [];

      for (var order in orders) {
        Delivery newDelivery = Delivery(
          id: UUID.generateUUID(),
          nameDelivery: baseDelivery.nameDelivery,
          scheduledDate: baseDelivery.scheduledDate,
          //TODO: Complete when exists entity Group
          // idGroup: order.idGroup,
          // nameGroup: order.nameGroup,
          foundation: NOMBRE_FUNDACION,
          updatedAt: DateTime.now(),
          type: TypesOfDeliveries.entregaDeCanastas,
          // idCoordinator: order.idCoordinator,
        );
        deliveries.add(newDelivery);

        List<Beneficiary> enableBeneficiaries = [];
        //await orderRepository.getBeneficiariesEnabled(order);
        for (var beneficiary in enableBeneficiaries) {
          DeliveryBeneficiary newDeliveryBeneficiary = DeliveryBeneficiary(
            id: UUID.generateUUID(),
            codeBeneficiary: beneficiary.code,
            nameBeneficiary: '${beneficiary.name}  ${beneficiary.lastName}',
            state: DeliveryStates.NOT_DELIVERED,
            updatedAt: DateTime.now(),
            idDelivery: newDelivery.id,
          );
          deliveryBeneficiaries.add(newDeliveryBeneficiary);
        }

        benefitsByDelivery.addAll(
          benefits.map((benefit) {
            return Benefit(
              id: UUID.generateUUID(),
              type: 'Canasta',
              description: benefit.description,
              idDelivery: newDelivery.id,
              updatedAt: DateTime.now(),
            );
          }).toList(),
        );
      }

      await benefitLocalDataSource.insertOrUpdate(benefitsByDelivery);
      benefitRemoteDataSource.insertList(benefitsByDelivery);

      await deliveryLocalDataSource.insertOrUpdate(deliveries);
      deliveryRemoteDataSource.insertList(deliveries);

      await deliveryBeneficiaryLocalDataSource.insertOrUpdate(
        deliveryBeneficiaries,
      );
      deliveryBeneficiaryRemoteDataSource.insertList(deliveryBeneficiaries);

      return Result.success(
        'Deliveries type basket orders generated successfully',
      );
    } catch (e) {
      log('Error generating deliveries for basket orders: $e');
      return Result.failure('Error generating deliveries for basket orders');
    }
  }

  @override
  Future<Result> generarEntregasDeAyudaEconomica(
    Delivery baseDelivery,
    List<Group> groups,
    Benefit benefit, //Single benefit because is economic aid (only one mount)
  ) async {
    try {
      List<Delivery> deliveries = [];
      List<DeliveryBeneficiary> deliveryBeneficiaries = [];
      List<Benefit> benefits = [];

      for (var group in groups) {
        Delivery newDelivery = Delivery(
          id: UUID.generateUUID(),
          nameDelivery: baseDelivery.nameDelivery,
          scheduledDate: baseDelivery.scheduledDate,
          idGroup: group.id,
          nameGroup: group.groupName,
          foundation: NOMBRE_FUNDACION,
          updatedAt: DateTime.now(),
          type: TypesOfDeliveries.entregaDeAyudaEconomica,
          idCoordinator: group.idCoordinator,
        );
        deliveries.add(newDelivery);

        List<Beneficiary> beneficiaries = await beneficiaryRepository
            .getBeneficiariesByGroupFuture(group.id);

        for (var beneficiary in beneficiaries) {
          DeliveryBeneficiary newDeliveryBeneficiary = DeliveryBeneficiary(
            id: UUID.generateUUID(),
            codeBeneficiary: beneficiary.code,
            nameBeneficiary: '${beneficiary.name}  ${beneficiary.lastName}',
            state: DeliveryStates.NOT_DELIVERED,
            updatedAt: DateTime.now(),
            idDelivery: newDelivery.id,
          );
          deliveryBeneficiaries.add(newDeliveryBeneficiary);
        }

        benefits.add(
          Benefit(
            id: UUID.generateUUID(),
            type: 'Efectivo',
            description: benefit.description,
            idDelivery: newDelivery.id,
            updatedAt: DateTime.now(),
          ),
        );
      }

      await deliveryLocalDataSource.insertOrUpdate(deliveries);
      deliveryRemoteDataSource.insertList(deliveries);

      await deliveryLocalDataSource.insertOrUpdate(deliveries);
      deliveryRemoteDataSource.insertList(deliveries);

      return Result.success(
        'Deliveries type financial aid generated successfully',
      );
    } catch (e) {
      log('Error generating deliveries for basket orders: $e');
      return Result.failure('Error generating deliveries for basket orders');
    }
  }

  @override
  Future<Result> generarEntregaDeMaterialEscolar(
    Delivery baseDelivery,
    List<Group> groups,
    List<Benefit> benefits,
  ) async {
    try {
      List<Delivery> deliveries = [];
      List<DeliveryBeneficiary> deliveryBeneficiaries = [];
      List<Benefit> benefitsByDelivery = [];

      for (var group in groups) {
        Delivery newDelivery = Delivery(
          id: UUID.generateUUID(),
          nameDelivery: baseDelivery.nameDelivery,
          scheduledDate: baseDelivery.scheduledDate,
          idGroup: group.id,
          nameGroup: group.groupName,
          foundation: NOMBRE_FUNDACION,
          updatedAt: DateTime.now(),
          type: TypesOfDeliveries.entregaDeMaterialEscolar,
          idCoordinator: group.idCoordinator,
        );
        deliveries.add(newDelivery);

        List<Beneficiary> beneficiaries = await beneficiaryRepository
            .getBeneficiariesByGroupFuture(group.id);

        for (var beneficiary in beneficiaries) {
          DeliveryBeneficiary newDeliveryBeneficiary = DeliveryBeneficiary(
            id: UUID.generateUUID(),
            codeBeneficiary: beneficiary.code,
            nameBeneficiary: '${beneficiary.name}  ${beneficiary.lastName}',
            state: DeliveryStates.NOT_DELIVERED,
            updatedAt: DateTime.now(),
            idDelivery: newDelivery.id,
          );
          deliveryBeneficiaries.add(newDeliveryBeneficiary);
        }

        benefitsByDelivery.addAll(
          benefits.map((benefit) {
            return Benefit(
              id: UUID.generateUUID(),
              type: 'Material Escolar',
              description: benefit.description,
              idDelivery: newDelivery.id,
              updatedAt: DateTime.now(),
            );
          }).toList(),
        );
      }

      await benefitLocalDataSource.insertOrUpdate(benefitsByDelivery);
      benefitRemoteDataSource.insertList(benefitsByDelivery);

      await deliveryLocalDataSource.insertOrUpdate(deliveries);
      deliveryRemoteDataSource.insertList(deliveries);

      await deliveryBeneficiaryLocalDataSource.insertOrUpdate(
        deliveryBeneficiaries,
      );
      deliveryBeneficiaryRemoteDataSource.insertList(deliveryBeneficiaries);

      return Result.success(
        'Deliveries type school supplies generated successfully',
      );
    } catch (e) {
      log('Error generating deliveries for basket orders: $e');
      return Result.failure('Error generating deliveries for basket orders');
    }
  }

  @override
  Stream<List<Benefit>> getBenefitsByDelivery(idDelivery) async* {
    try {
      final localBenefits = await benefitLocalDataSource.getByDelivery(
        idDelivery,
      );

      if (localBenefits.isNotEmpty) {
        yield localBenefits;
      }
      final remoteBenefits = await benefitRemoteDataSource.getByDelivery(
        idDelivery,
      );

      if (remoteBenefits.isNotEmpty) {
        await benefitLocalDataSource.insertOrUpdate(remoteBenefits);
        yield remoteBenefits;
      }
      yield [];
    } catch (e) {
      log('Error getting benefits by delivery: $e');
      yield [];
    }
  }

  @override
  Stream<List<DeliveryBeneficiary>> getDeliveriesBeneficiaries(
    String idDelivery,
  ) async* {
    try {
      final localDeliveryBeneficiaries =
          await deliveryBeneficiaryLocalDataSource.getByDelivery(idDelivery);

      if (localDeliveryBeneficiaries.isNotEmpty) {
        yield localDeliveryBeneficiaries;
      }

      final remoteDeliveryBeneficiaries =
          await deliveryBeneficiaryLocalDataSource.getByDelivery(idDelivery);

      if (remoteDeliveryBeneficiaries.isNotEmpty) {
        await deliveryBeneficiaryLocalDataSource.insertOrUpdate(
          remoteDeliveryBeneficiaries,
        );
        yield remoteDeliveryBeneficiaries;
      }
      yield [];
    } catch (e) {
      log('Error getting delivery beneficiaries by delivery: $e');
      yield [];
    }
  }

  @override
  Future<Photo?> savePhotoDelivery(
    File photoFile,
    String nameBeneficiary,
  ) async {
    try {
      Photo photoDelivery = Photo(
        id: UUID.generateUUID(),
        name: 'delivery_photo_beneficiary_$nameBeneficiary',
      );

      if (await NetworkUtils.hasRealInternet()) {
        final urlRemote = await UploadImageRemote.saveImage(photoFile);

        if (urlRemote != null) {
          photoDelivery = photoDelivery.copyWith(urlRemote: urlRemote);
        }
      }

      final urlLocal = await UploadImageLocal.saveImageLocally(
        photoFile,
        photoDelivery.name,
      );

      photoDelivery = photoDelivery.copyWith(urlLocal: urlLocal);

      await photoLocalDataSource.insert(photoDelivery);
      photoRemoteDataSource.insert(photoDelivery);

      return photoDelivery;
    } catch (e) {
      log('Error saving photo delivery: $e');
      return null;
    }
  }

  @override
  Future<void> saveProductsBeneficiary(
    List<ProductBeneficiary> productsBeneficiary,
  ) async {
    try {
      await productBeneficiaryLocalDataSource.insertOrUpdate(
        productsBeneficiary,
      );
      productBeneficiaryRemoteDataSource.insertList(productsBeneficiary);
    } catch (e) {
      log('Error saving products beneficiary: $e');
    }
  }

  @override
  Future<Result> saveDeliveryBeneficiary(
    DeliveryBeneficiary deliveryBeneficiary,
  ) async {
    try {
      await deliveryBeneficiaryLocalDataSource.update(deliveryBeneficiary);
      deliveryBeneficiaryRemoteDataSource.update(deliveryBeneficiary);

      return Result.success('Delivery beneficiary saved successfully');
    } catch (e) {
      log('Error saving delivery beneficiary: $e');
      return Result.failure('Error saving delivery beneficiary');
    }
  }

  @override
  Future<Result> saveDeliveryFinancialAidBeneficiary(
    DeliveryBeneficiary deliveryBeneficiary,
    Photo photoDelivery,
    List<Benefit> benefits,
    List<ProductBeneficiary> productsDeliveried,
  ) async {
    try {
      await deliveryBeneficiaryLocalDataSource.update(deliveryBeneficiary);
      deliveryBeneficiaryRemoteDataSource.update(deliveryBeneficiary);

      // Save photo
      // Assuming you have a method to save photo locally and remotely
      // await photoLocalDataSource.savePhoto(photoDelivery);
      // await photoRemoteDataSource.savePhoto(photoDelivery);

      // Update benefits if needed
      for (var benefit in benefits) {
        await benefitLocalDataSource.update(benefit);
        await benefitRemoteDataSource.update(benefit);
      }

      // Save products delivered
      for (var product in productsDeliveried) {
        await productBeneficiaryLocalDataSource.insert(product);
        await productBeneficiaryRemoteDataSource.insert(product);
      }

      return Result.success('Delivery beneficiary saved successfully');
    } catch (e) {
      log('Error saving delivery beneficiary: $e');
      return Result.failure('Error saving delivery beneficiary');
    }
  }

  @override
  Future<DeliveryBeneficiary> getDeliveryBeneficiary(idDeliveryBeneficiary) {
    // TODO: implement getDeliveryBeneficiary
    throw UnimplementedError();
  }

  @override
  Future<Photo?> getPhotoOfDelivery(String idPhoto) async {
    try {
      Photo? photo = await photoLocalDataSource.getPhoto(idPhoto);
      if (photo != null) {
        photo = await verifyUrlRemoteAndUpdate(photo);
        return photo;
      }
      photo = await photoRemoteDataSource.getPhoto(idPhoto);

      if (photo != null) {
        photo = await verifyUrlRemoteAndUpdate(photo);
        await photoLocalDataSource.insert(photo);
      }

      return photo;
    } catch (e) {
      log('Error getting photo of delivery: $e');
      return null;
    }
  }

  Future<Photo> verifyUrlRemoteAndUpdate(Photo photo) async {
    if (photo.urlRemote.isEmpty && await File(photo.urlLocal).exists()) {
      final urlRemote = await UploadImageRemote.saveImage(File(photo.urlLocal));

      if (urlRemote != null) {
        photo = photo.copyWith(urlRemote: urlRemote);
        await photoLocalDataSource.update(photo);
        photoRemoteDataSource.updatePhoto(photo);
      }
    }
    return photo;
  }

  @override
  Future<List<ProductBeneficiary>> getProductsBeneficiary(idBenefit) {
    // TODO: implement getProductsBeneficiary
    throw UnimplementedError();
  }

  @override
  Future<void> saveFinancialAid(FinancialAid financialAid) async {
    try {
      await financialAidLocalDataSource.insert(financialAid);
      financialAidRemoteDataSource.insert(financialAid);
    } catch (e) {
      log('Error saving financial aid: $e');
    }
  }
}
