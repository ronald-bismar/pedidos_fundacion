// Enum para identificar las pantallas
import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/features/beneficiarios/presentation/screens/lista_beneficiarios_screen.dart';
import 'package:pedidos_fundacion/features/encargados/presentation/screens/auth_screen.dart';
import 'package:pedidos_fundacion/features/encargados/presentation/screens/lista_encargados_screen.dart';

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
        return AuthCoordinatorScreen();
      case ScreenType.entregas:
        return AuthCoordinatorScreen();
      case ScreenType.personal:
        return ListCoordinatorsScreen();
      case ScreenType.asistenciaBeneficiarios:
        return AuthCoordinatorScreen();
      case ScreenType.beneficiarios:
        return ListBeneficiariesScreen();
      case ScreenType.reportes:
        return AuthCoordinatorScreen();
    }
  }
}
