import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/core/widgets/text_normal.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';
import 'package:pedidos_fundacion/features/encargados/presentation/providers/encargados_provider.dart';
import 'package:pedidos_fundacion/features/encargados/presentation/screens/auth_screen.dart';
import 'package:pedidos_fundacion/features/encargados/presentation/widgets/card_coordinator.dart';

class ListCoordinatorsScreen extends ConsumerStatefulWidget {
  final String coordinatorId;
  const ListCoordinatorsScreen({this.coordinatorId = '', super.key});

  @override
  ConsumerState<ListCoordinatorsScreen> createState() =>
      _ListaCoordinatorsScreenState();
}

class _ListaCoordinatorsScreenState
    extends ConsumerState<ListCoordinatorsScreen> {
  @override
  Widget build(BuildContext context) {
    final coordinatorsAsyncValue = ref.watch(coordinatorsProvider);

    return Scaffold(
      body: Container(
        color: primary,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                title('Lista de Encargados'),
                const SizedBox(height: 20),
                Expanded(
                  child: coordinatorsAsyncValue.when(
                    loading: () => _loadingState(),

                    error: (error, stackTrace) => _errorState(error),

                    data: (coordinators) {
                      if (coordinators.isEmpty) {
                        return _emptyState();
                      }
                      return _loadedState(coordinators);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          cambiarPantalla(context, AuthCoordinatorScreen());
        },
        backgroundColor: quaternary,
        foregroundColor: dark,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _loadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  Widget _errorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          subTitle('Error al cargar encargados', fontWeight: FontWeight.w600),
          const SizedBox(height: 8),
          textNormal(error.toString(), textColor: white.withOpacity(0.8)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Refrescar los datos
              ref.invalidate(coordinatorsProvider);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.white.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          subTitle('No hay encargados', fontWeight: FontWeight.w600),
          const SizedBox(height: 8),
          textNormal('Aún no se han registrado encargados'),
        ],
      ),
    );
  }

  Widget _loadedState(List<Coordinator> coordinators) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(coordinatorsProvider);
      },
      child: ListView.builder(
        itemCount: coordinators.length,
        itemBuilder: (context, index) {
          return CardCoordinator(coordinators[index]);
        },
      ),
    );
  }
}
