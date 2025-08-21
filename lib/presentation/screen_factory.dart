// Enum para identificar las pantallas
import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/screens/auth_screen.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/presentation/screens/lista_beneficiarios_screen.dart';
import 'package:pedidos_fundacion/features/orders/presentation/screens/group_registration_screen.dart';
import 'package:pedidos_fundacion/features/orders/presentation/screens/place_registration_screen.dart';

enum ScreenType {
  pedidos,
  entregas,
  personal,
  asistenciaBeneficiarios,
  beneficiarios,
  reportes,
  lugares,
  grupos,
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
        return GroupRegistrationScreen();
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
        return GroupRegistrationScreen();
    }
  }
}
