import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/drop_down_options.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/core/widgets/text_normal.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';
import 'package:pedidos_fundacion/domain/entities/programa.dart';
import 'package:pedidos_fundacion/features/beneficiarios/presentation/providers/beneficiaries_provider.dart';
import 'package:pedidos_fundacion/features/beneficiarios/presentation/providers/grupos_provider.dart';
import 'package:pedidos_fundacion/features/beneficiarios/presentation/screens/auth_beneficiario_screen.dart';
import 'package:pedidos_fundacion/features/beneficiarios/presentation/widgets/card_beneficiario.dart';

class ListBeneficiariesScreen extends ConsumerStatefulWidget {
  final String beneficiaryId;
  const ListBeneficiariesScreen({this.beneficiaryId = '', super.key});

  @override
  ConsumerState<ListBeneficiariesScreen> createState() =>
      _ListaBeneficiariesScreenState();
}

class _ListaBeneficiariesScreenState
    extends ConsumerState<ListBeneficiariesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final groups = ref
          .read(groupsProvider)
          .maybeWhen(data: (data) => data, orElse: () => []);
      if (groups.isNotEmpty) {
        ref.read(selectedGroupProvider.notifier).state = groups.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedGroup = ref.watch(selectedGroupProvider);
    final List<Group> groups = ref
        .watch(groupsProvider)
        .maybeWhen(data: (data) => data, orElse: () => []);

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
                title('Lista de Beneficiarios'),
                const SizedBox(height: 20),
                DropDownOptions(
                  itemInitial:
                      selectedGroup?.groupName ?? 'Selecciona un grupo',
                  onSelect: (value) => _onGroupSelected(value, groups),
                  items: groups.map((group) => group.groupName).toList(),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Consumer(
                    builder: (context, ref, child) {
                      final beneficiariesAsyncValue = ref.watch(
                        beneficiariesStreamProvider(selectedGroup?.id ?? ''),
                      );

                      return beneficiariesAsyncValue.when(
                        loading: () => _loadingState(),
                        error: (error, stackTrace) => _errorState(error),
                        data: (beneficiaries) {
                          if (beneficiaries.isEmpty) {
                            return _emptyState();
                          }
                          return _loadedState(beneficiaries);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => cambiarPantalla(context, AuthBeneficiaryScreen()),
        icon: const Icon(Icons.person_add),
        label: const Text('Nuevo beneficiario'),
        backgroundColor: quaternary,
        foregroundColor: dark,
      ),
    );
  }

  void _onGroupSelected(String groupDisplayName, List<Group> groups) {
    final Group foundGroup = groups.firstWhere(
      (group) => group.groupName == groupDisplayName,
      orElse: () => groups.first,
    );
    ref.read(selectedGroupProvider.notifier).state = foundGroup;
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
