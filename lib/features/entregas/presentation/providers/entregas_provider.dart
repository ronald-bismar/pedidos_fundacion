import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/features/entregas/data/entrega_repository_impl.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/entrega.dart';

final deliveriesProvider = StreamProvider<List<Delivery>>((ref) {
  final deliveryRepository = ref.watch(deliveryRepoProvider);
  return deliveryRepository.getDeliveriesByGroups();
});
