// Enum para identificar las pantallas
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/presentation/screens/asistencia_screen.dart';
import 'package:pedidos_fundacion/features/beneficiarios/presentation/screens/lista_beneficiarios_screen.dart';
import 'package:pedidos_fundacion/features/encargados/presentation/screens/auth_screen.dart';
import 'package:pedidos_fundacion/features/encargados/presentation/screens/lista_encargados_screen.dart';
import 'package:pedidos_fundacion/features/entregas/presentation/screens/lista_entregas_screen.dart';
import 'package:pedidos_fundacion/features/orders/presentation/screens/group_selection_screen.dart';
import 'package:pedidos_fundacion/features/places/presentation/screens/place_registration_screen.dart';
import 'package:pedidos_fundacion/features/groups/presentation/screens/groups_screen.dart';
import 'package:pedidos_fundacion/features/orders/presentation/screens/orders_screen.dart';
import 'package:pedidos_fundacion/features/places/domain/entities/place_entity.dart';
import 'package:pedidos_fundacion/features/orders/domain/entities/order_entity.dart';
import 'package:pedidos_fundacion/features/orders/presentation/screens/orders_list_screen.dart';
import 'package:pedidos_fundacion/features/orders/presentation/screens/place_selection_screen.dart';
import 'package:pedidos_fundacion/features/orders/presentation/screens/group_selection_screen.dart';
import 'package:pedidos_fundacion/features/orders/presentation/screens/orders_screen.dart';
import 'package:pedidos_fundacion/features/entregas/presentation/screens/lista_entregas_screen.dart';
import 'package:pedidos_fundacion/features/encargados/presentation/screens/lista_encargados_screen.dart';

enum ScreenType {
  pedidos,
  pedidos2,
  entregas,
  personal,
  asistenciaBeneficiarios,
  beneficiarios,
  reportes,
  lugares,
  grupos,
  listaPedidos,
}

// Factory para crear las pantallas
class ScreenFactory {
  // Singleton pattern para evitar múltiples instancias
  static final ScreenFactory _instance = ScreenFactory._internal();
  factory ScreenFactory() => _instance;
  ScreenFactory._internal();

  // Método principal del factory
  Widget createScreen(
    ScreenType screenType, {
    Map<String, dynamic>? arguments,
  }) {
    switch (screenType) {
      case ScreenType.pedidos:
        return PlaceSelectionScreen();
      case ScreenType.pedidos2:
        return OrdersScreen();
      case ScreenType.listaPedidos:
        return OrdersListScreen();


        
      case ScreenType.entregas:
        return ListDeliveriesScreen();
      case ScreenType.personal:
        return ListCoordinatorsScreen();
      case ScreenType.asistenciaBeneficiarios:
        return AttendanceBeneficiaryScreen();
      case ScreenType.beneficiarios:
        return ListBeneficiariesScreen();
      case ScreenType.reportes:
        return AuthCoordinatorScreen();
      case ScreenType.lugares:
        return PlaceRegistrationScreen();
      case ScreenType.grupos:
        return GroupsScreen();
    }
  }
}
