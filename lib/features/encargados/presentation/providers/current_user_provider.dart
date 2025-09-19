// lib/features/encargados/presentation/providers/current_user_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/preferences_usuario.dart';
import '../../../../domain/entities/encargado.dart';

// Provider that holds the currently logged-in user.
final currentUserProvider = FutureProvider<Coordinator?>((ref) async {
  final preferences = ref.watch(preferencesUsuarioProvider);
  
  // ✅ Use the correct method name from your class
  return preferences.getPreferencesCoordinator();
});