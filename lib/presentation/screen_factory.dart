// Enum para identificar las pantallas
import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/screens/auth_screen.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/presentation/screens/auth_beneficiario_screen.dart';

enum ScreenType {
  pedidos,
  entregas,
  personal,
  asistenciaBeneficiarios,
  beneficiarios,
  reportes,
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
        return AuthScreen();
      case ScreenType.entregas:
        return AuthScreen();
      case ScreenType.personal:
        return AuthScreen();
      case ScreenType.asistenciaBeneficiarios:
        return AuthScreen();
      case ScreenType.beneficiarios:
        return AuthBeneficiaryScreen();
      case ScreenType.reportes:
        return AuthScreen();
    }
  }
}
