// Enum para identificar las pantallas
import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/screens/auth_screen.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/presentation/screens/lista_beneficiarios_screen.dart';
import 'package:pedidos_fundacion/features/groups/presentation/screens/groups_screen.dart';
import 'package:pedidos_fundacion/features/places/presentation/screens/place_registration_screen.dart';
import 'package:pedidos_fundacion/features/orders/presentation/screens/orders_screen.dart';
import 'package:pedidos_fundacion/features/orders/presentation/screens/place_selection_screen.dart';


enum ScreenType {
  pedidos,
  entregas,
  personal,
  asistenciaBeneficiarios,
  beneficiarios,
  reportes,
  lugares,
  grupos,
  registro_pedidos,
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
      case ScreenType.registro_pedidos:
        return PlaceSelectionScreen();
      case ScreenType.pedidos:
        return OrdersScreen();
      case ScreenType.entregas:
        return PlaceRegistrationScreen();
      case ScreenType.personal:
        return AuthScreen();
      case ScreenType.asistenciaBeneficiarios:
        return AuthScreen();
      case ScreenType.beneficiarios:
        return ListBeneficiariesScreen();
      case ScreenType.reportes:
        return AuthScreen();
      case ScreenType.lugares:
        return PlaceRegistrationScreen();
      case ScreenType.grupos:
        return GroupsScreen();
      default:
        throw UnimplementedError('ScreenType $screenType no está implementado');
    }
  }
}
