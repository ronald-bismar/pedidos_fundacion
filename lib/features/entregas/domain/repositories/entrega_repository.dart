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
  Future<Result> generarEntregasParaPedidosDeCanastas(
    Delivery baseDelivery,
    List<Order> orders,
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
  Future<Result> generarEntregaDeOtroTipo(
    Delivery baseDelivery,
    List<Group> groups,
    List<Benefit> benefits,
  );
  Future<List<Delivery>> getDeliveries();
  Future<List<Order>> getOrdersForDelivery();
  Future<List<DeliveryBeneficiary>> getDeliveriesBeneficiaries(
    String idDelivery,
  );
  Future<DeliveryBeneficiary> getDeliveryBeneficiary(idDeliveryBeneficiary);
  Future<Photo?> getPhotoOfDeliver(idDeliveryBeneficiary);
  Future<List<Benefit>> getBenefitByDeliveryBeneficiary(idDeliveryBeneficiary);
  Future<List<ProductBeneficiary>> getProductsBeneficiary(idBenefit);
  Future<Result> saveDeliveryBeneficiary(
    DeliveryBeneficiary deliveryBeneficiary,
    Photo photoDelivery,
    List<Benefit> benefits,
    List<ProductBeneficiary> productsDeliveried,
  );
}
