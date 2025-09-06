import 'package:pedidos_fundacion/core/results/result_global.dart';
import 'package:pedidos_fundacion/domain/entities/foto.dart';
import 'package:pedidos_fundacion/domain/entities/programa.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/ayuda_economica.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/beneficio.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/entrega.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/entrega_beneficiario.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/producto_beneficiario.dart';
import 'package:pedidos_fundacion/features/orders/domain/entities/order_entity.dart';

abstract class EntregaRepository {
  Stream<List<Delivery>> getDeliveriesByGroups();
  List<String> getTypesOfDeliveries();
  Stream<List<Order>> getOrdersForDelivery();
  Future<Result> generarEntregasParaPedidosDeCanastas(
    Delivery baseDelivery,
    List<Order> orders,
    List<Benefit> benefits,
  );
  Future<Result> generarEntregasDeAyudaEconomica(
    Delivery baseDelivery,
    List<Group> groups,
    FinancialAid financialAid,
  );
  Future<Result> generarEntregaDeMaterialEscolar(
    Delivery baseDelivery,
    List<Group> groups,
    List<Benefit> benefits,
  );
  Stream<List<Benefit>> getBenefitsByDelivery(idDelivery);
  Stream<List<DeliveryBeneficiary>> getDeliveriesBeneficiaries(
    String idDelivery,
  );
  Future<Result> saveDeliveryBeneficiary(
    DeliveryBeneficiary deliveryBeneficiary,
    Photo photoDelivery,
    List<Benefit> benefits,
    List<ProductBeneficiary> productsDeliveried,
  );
  Future<DeliveryBeneficiary> getDeliveryBeneficiary(idDeliveryBeneficiary);
  Future<Photo?> getPhotoOfDeliver(idDeliveryBeneficiary);
  Future<List<ProductBeneficiary>> getProductsBeneficiary(idBenefit);
}
