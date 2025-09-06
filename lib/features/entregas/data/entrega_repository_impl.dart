import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/results/result_global.dart';
import 'package:pedidos_fundacion/core/utils/uuid.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';
import 'package:pedidos_fundacion/domain/entities/foto.dart';
import 'package:pedidos_fundacion/domain/entities/programa.dart';
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

      final countDeliveries = orders.length;

      for (int i = 0; i < countDeliveries; i++) {
        final deliveryId = UUID.generateUUID();
        Delivery newDelivery = Delivery(
          id: deliveryId,
          nameDelivery: baseDelivery.nameDelivery,
          scheduledDate: baseDelivery.scheduledDate,
          //TODO: Complete when exists entity Group
          // idGroup: orders[i].idGroup,
          // nameGroup: orders[i].nameGroup,
          foundation: baseDelivery.foundation,
          updatedAt: DateTime.now(),
          type: baseDelivery.type,
          // idCoordinator: orders[i].idCoordinator,
        );
        deliveries.add(newDelivery);

        List<Beneficiary> enableBeneficiaries = [];
        // orderRepository.getBeneficiariesEnabled(orders[i]);
        for (var ben in enableBeneficiaries) {
          DeliveryBeneficiary newDeliveryBeneficiary = DeliveryBeneficiary(
            id: UUID.generateUUID(),
            codeBeneficiary: ben.code,
            nameBeneficiary: '${ben.name}  ${ben.lastName}',
            state: DeliveryStates.NOT_DELIVERED,
            updatedAt: DateTime.now(),
          );
          deliveryBeneficiaries.add(newDeliveryBeneficiary);
        }
      }

      await deliveryLocalDataSource.insertOrUpdate(deliveries);
      deliveryRemoteDataSource.insertDeliveryList(deliveries);

      return Result.success('Deliveries generated successfully');
    } catch (e) {
      log('Error generating deliveries for basket orders: $e');
      return Result.failure('Error generating deliveries for basket orders');
    }
  }

  @override
  Future<Result> generarEntregasDeAyudaEconomica(
    Delivery baseDelivery,
    List<Group> groups,
    FinancialAid financialAid,
  ) async {
    try {
      final countDeliveries = groups.length;
      List<Delivery> deliveries = [];
      for (int i = 0; i < countDeliveries; i++) {
        Delivery newDelivery = Delivery(
          id: UUID.generateUUID(),
          nameDelivery: baseDelivery.nameDelivery,
          scheduledDate: baseDelivery.scheduledDate,
          idGroup: groups[i].id,
          nameGroup: groups[i].groupName,
          foundation: baseDelivery.foundation,
          updatedAt: DateTime.now(),
          type: baseDelivery.type,
          idCoordinator: groups[i].idCoordinator,
        );
        deliveries.add(newDelivery);
      }

      await deliveryLocalDataSource.insertOrUpdate(deliveries);
      deliveryRemoteDataSource.insertDeliveryList(deliveries);

      return Result.success('Deliveries generated successfully');
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
      final countDeliveries = groups.length;
      List<Delivery> deliveries = [];
      for (int i = 0; i < countDeliveries; i++) {
        Delivery newDelivery = Delivery(
          id: UUID.generateUUID(),
          nameDelivery: baseDelivery.nameDelivery,
          scheduledDate: baseDelivery.scheduledDate,
          idGroup: groups[i].id,
          nameGroup: groups[i].groupName,
          foundation: baseDelivery.foundation,
          updatedAt: DateTime.now(),
          type: baseDelivery.type,
          idCoordinator: groups[i].idCoordinator,
        );
        deliveries.add(newDelivery);
      }

      await deliveryLocalDataSource.insertOrUpdate(deliveries);
      deliveryRemoteDataSource.insertDeliveryList(deliveries);

      return Result.success('Deliveries generated successfully');
    } catch (e) {
      log('Error generating deliveries for basket orders: $e');
      return Result.failure('Error generating deliveries for basket orders');
    }
  }

  @override
  Stream<List<Benefit>> getBenefitsByDelivery(idDelivery) {
    // TODO: implement getDeliveriesBeneficiaries
    throw UnimplementedError();
  }

  @override
  Stream<List<DeliveryBeneficiary>> getDeliveriesBeneficiaries(
    String idDelivery,
  ) {
    // TODO: implement getDeliveriesBeneficiaries
    throw UnimplementedError();
  }

  @override
  Future<Result> saveDeliveryBeneficiary(
    DeliveryBeneficiary deliveryBeneficiary,
    Photo photoDelivery,
    List<Benefit> benefits,
    List<ProductBeneficiary> productsDeliveried,
  ) {
    // TODO: implement saveDeliveryBeneficiary
    throw UnimplementedError();
  }

  @override
  Future<DeliveryBeneficiary> getDeliveryBeneficiary(idDeliveryBeneficiary) {
    // TODO: implement getDeliveryBeneficiary
    throw UnimplementedError();
  }

  @override
  Future<Photo?> getPhotoOfDeliver(idDeliveryBeneficiary) {
    // TODO: implement getPhotoOfDeliver
    throw UnimplementedError();
  }

  @override
  Future<List<ProductBeneficiary>> getProductsBeneficiary(idBenefit) {
    // TODO: implement getProductsBeneficiary
    throw UnimplementedError();
  }
}
