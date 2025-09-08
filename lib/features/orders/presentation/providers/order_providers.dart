// lib/features/orders/presentation/providers/order_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/order_remote_datasource.dart';
import '../../data/repositories_impl/order_repository_impl.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/add_order_usecase.dart';
import '../../domain/usecases/block_order_usecase.dart';
import '../../domain/usecases/delete_order_usecase.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/restore_order_usecase.dart';
import '../../domain/usecases/update_order_usecase.dart';
import '../notifiers/order_notifier.dart';
import '../notifiers/orders_list_notifier.dart';
import '../notifiers/order_state.dart';

import '../../../groups/domain/entities/group_entity.dart';
import '../../../places/domain/entities/place_entity.dart';
import '../../../groups/data/datasources/group_remote_datasource.dart';
import '../../../places/data/datasources/place_remote_datasource.dart';
import '../../../../domain/entities/beneficiario.dart';
import '../../../../data/datasources/beneficiario/remote_datasource.dart';
import '../../../../di/services_provider.dart';

class OrderStatusArgs {
  final String groupId;
  final String month;
  OrderStatusArgs({required this.groupId, required this.month});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderStatusArgs &&
          runtimeType == other.runtimeType &&
          groupId == other.groupId &&
          month == other.month;

  @override
  int get hashCode => groupId.hashCode ^ month.hashCode;
}

// Providers de la capa de datos
final orderRemoteDataSourceProvider = Provider((ref) => OrderRemoteDataSource());
final orderRepositoryProvider = Provider((ref) {
  final remoteDataSource = ref.read(orderRemoteDataSourceProvider);
  return OrderRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Proveedores para obtener datos estáticos
final getOrdersUseCaseProvider = Provider((ref) {
  final repo = ref.read(orderRepositoryProvider);
  return GetOrdersUseCase(repo);
});

final addOrderUseCaseProvider = Provider((ref) {
  final repo = ref.read(orderRepositoryProvider);
  return AddOrderUseCase(repo);
});

final updateOrderUseCaseProvider = Provider((ref) {
  final repo = ref.read(orderRepositoryProvider);
  return UpdateOrderUseCase(repo);
});

final deleteOrderUseCaseProvider = Provider((ref) {
  final repo = ref.read(orderRepositoryProvider);
  return DeleteOrderUseCase(repo);
});

final restoreOrderUseCaseProvider = Provider((ref) {
  final repo = ref.read(orderRepositoryProvider);
  return RestoreOrderUseCase(repo);
});

final blockOrderUseCaseProvider = Provider((ref) {
  final repo = ref.read(orderRepositoryProvider);
  return BlockOrderUseCase(repo);
});

final placeRemoteDataSourceProvider = Provider((ref) => PlaceRemoteDataSource());
final groupRemoteDataSourceProvider = Provider((ref) => GroupRemoteDataSource());
final beneficiaryRemoteDataSourceProvider = Provider((ref) {
  final firestore = ref.watch(firestoreProvider);
  return BeneficiaryRemoteDataSource(firestore);
});

final placesProvider = FutureProvider<List<PlaceEntity>>((ref) async {
  final dataSource = ref.read(placeRemoteDataSourceProvider);
  return dataSource.getPlaces();
});

final allGroupsProvider = StreamProvider<List<GroupEntity>>((ref) {
  final dataSource = ref.read(groupRemoteDataSourceProvider);
  return dataSource.getGroups();
});

final orderStatusProvider = FutureProvider.family<bool, OrderStatusArgs>((ref, args) async {
  final dataSource = ref.read(orderRemoteDataSourceProvider);
  return dataSource.hasOrderForGroupAndMonth(
    groupId: args.groupId,
    month: args.month,
  );
});

final beneficiariesByGroupProvider = StreamProvider.family<List<Beneficiary>, String>((ref, groupId) {
  final dataSource = ref.read(beneficiaryRemoteDataSourceProvider);
  return dataSource.streamByGroup(groupId);
});


final orderNotifierProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  final addUseCase = ref.read(addOrderUseCaseProvider);
  return OrderNotifier(addUseCase: addUseCase);
});

final ordersListNotifierProvider = AsyncNotifierProvider<OrdersListNotifier, List<OrderEntity>>(() {
  return OrdersListNotifier();
});