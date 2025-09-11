// lib/features/orders/presentation/notifiers/order_state.dart

class OrderState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  OrderState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });
}