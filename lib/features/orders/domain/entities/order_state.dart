// lib/features/orders/domain/entities/order_state.dart

enum OrderState {
  active(1),
  deleted(0),
  blocked(2);
 

  final int value;
  const OrderState(this.value);

  factory OrderState.fromInt(int value) {
    return OrderState.values.firstWhere((e) => e.value == value);
  }
}