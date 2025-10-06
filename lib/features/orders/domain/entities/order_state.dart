// lib/features/orders/domain/entities/order_state.dart

enum OrderState {
  // Estados de ciclo de vida de una orden
  pending(0),       // La orden ha sido creada, esperando ser revisada/procesada
  active(1),        // La orden está activa y en proceso 
  processed(2),     // La orden ha sido procesada o está en preparación
  delivered(3),     // La orden ha sido entregada
  cancelled(4),     // La orden ha sido cancelada
  
  // Estados de gestión/excepción
  blocked(5),       // La orden está bloqueada temporalmente (ej. por un problema)
  deleted(6);       // La orden ha sido eliminada lógicamente (no visible, pero en BD)

  final int value;
  const OrderState(this.value);

  factory OrderState.fromInt(int value) {
    return OrderState.values.firstWhere(
      (e) => e.value == value,
      orElse: () => OrderState.pending, 
    );
  }

  // Opcional: Para mostrar un nombre legible en la UI
  String get displayName {
    switch (this) {
      case OrderState.pending:
        return 'Pendiente';
      case OrderState.active:
        return 'Activa';
      case OrderState.processed:
        return 'En Proceso';
      case OrderState.delivered:
        return 'Entregada';
      case OrderState.cancelled:
        return 'Cancelada';
      case OrderState.blocked:
        return 'Bloqueada';
      case OrderState.deleted:
        return 'Eliminada';
    }
  }
}