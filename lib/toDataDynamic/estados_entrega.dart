class DeliveryStates {
  static const String DELIVERED = 'Entregado';
  static const String NOT_DELIVERED = 'No Entregado';

  static List<String> getAllStates() {
    return [DELIVERED, NOT_DELIVERED];
  }
}
