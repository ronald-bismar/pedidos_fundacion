import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/core/widgets/text_normal.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/presentation/providers/beneficiaries_provider.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/presentation/screens/auth_beneficiario_screen.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/presentation/widgets/card_beneficiario.dart';

class ListCoordinatorsScreen extends ConsumerStatefulWidget {
  final String beneficiaryId;
  const ListCoordinatorsScreen({this.beneficiaryId = '', super.key});

  @override
  ConsumerState<ListCoordinatorsScreen> createState() =>
      _ListaCoordinatorsScreenState();
}

class _ListaCoordinatorsScreenState
    extends ConsumerState<ListCoordinatorsScreen> {
  @override
  Widget build(BuildContext context) {
    final beneficiariesAsyncValue = ref.watch(
      beneficiariesStreamProvider(
        // selectedGroupId
        '',
      ),
    );

    return Scaffold(
      body: Container(
        color: primary,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                title('Lista de Encargados'),
                const SizedBox(height: 20),
                Expanded(
                  child: beneficiariesAsyncValue.when(
                    loading: () => _loadingState(),

                    error: (error, stackTrace) => _errorState(error),

                    data: (beneficiaries) {
                      if (beneficiaries.isEmpty) {
                        return _emptyState();
                      }
                      return _loadedState(beneficiaries);
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
          cambiarPantalla(context, AuthBeneficiaryScreen());
        },
        backgroundColor: quaternary,
        foregroundColor: dark,
        child: const Icon(Icons.filter),
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
          subTitle(
            'Error al cargar beneficiarios',
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 8),
          textNormal(error.toString(), textColor: white.withOpacity(0.8)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Refrescar los datos
              ref.invalidate(beneficiariesStreamProvider);
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
          subTitle('No hay beneficiarios', fontWeight: FontWeight.w600),
          const SizedBox(height: 8),
          textNormal('Aún no se han registrado beneficiarios en este grupo'),
        ],
      ),
    );
  }

  Widget _loadedState(List<Beneficiary> beneficiaries) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(beneficiariesStreamProvider);
      },
      child: ListView.builder(
        itemCount: beneficiaries.length,
        itemBuilder: (context, index) {
          return CardBeneficiary(beneficiaries[index]);
        },
      ),
    );
  }
}
