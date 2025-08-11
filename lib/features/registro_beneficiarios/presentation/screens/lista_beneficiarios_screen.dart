import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/drop_down_options.dart';
import 'package:pedidos_fundacion/core/widgets/snackbar.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';
import 'package:pedidos_fundacion/domain/entities/programa.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/presentation/providers/beneficiaries_provider.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/presentation/providers/gropos_provider.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/presentation/screens/auth_beneficiario_screen.dart';

class ListBeneficiariesScreen extends ConsumerStatefulWidget {
  final String beneficiaryId;
  const ListBeneficiariesScreen({this.beneficiaryId = '', super.key});

  @override
  ConsumerState<ListBeneficiariesScreen> createState() =>
      _ListaBeneficiariesScreenState();
}

class _ListaBeneficiariesScreenState
    extends ConsumerState<ListBeneficiariesScreen> {
  List<Group> groups = [];
  Group? selectedGroup;
  String selectedGroupId = 'group_001'; // ID del grupo por defecto

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<Group>>>(groupsProvider, (previous, next) {
      next.whenData((data) {
        groups = data;
        // Si es la primera carga y no hay grupo seleccionado, tomar el primero
        if (selectedGroup == null && groups.isNotEmpty) {
          selectedGroup = groups.first;
          selectedGroupId =
              selectedGroup!.id; // Asegúrate de que Group tenga un campo id
        }
      });

      if (next.hasError) {
        MySnackBar.error(context, 'No se pudo obtener los grupos.');
      }
    });

    final beneficiariesAsyncValue = ref.watch(
      beneficiariesStreamProvider(selectedGroupId),
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
                title('Lista de Beneficiarios'),
                const SizedBox(height: 20),
                DropDownOptions(
                  itemInitial:
                      selectedGroup?.groupName ?? 'Selecciona un grupo',
                  onSelect: (value) {
                    _onGroupSelected(value);
                  },
                  items: groups
                      .map(
                        (group) =>
                            '${group.groupName} ${group.ageRange.toString()}',
                      )
                      .toList(),
                ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          cambiarPantalla(context, AuthBeneficiaryScreen());
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Nuevo beneficiario'),
        backgroundColor: quaternary,
        foregroundColor: dark,
      ),
    );
  }

  void _onGroupSelected(String groupDisplayName) {
    // Buscar el grupo por el nombre mostrado
    final Group foundGroup = groups.firstWhere(
      (group) =>
          '${group.groupName} ${group.ageRange.toString()}' == groupDisplayName,
      orElse: () => groups.first, // Fallback al primer grupo si no se encuentra
    );

    setState(() {
      selectedGroup = foundGroup;
      selectedGroupId = foundGroup.id; // Cambiar el ID del grupo
    });
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
          const Text(
            'Error al cargar beneficiarios',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
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
          const Text(
            'No hay beneficiarios',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Aún no se han registrado beneficiarios en este grupo',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
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
          return cardBeneficiary(beneficiaries, index);
        },
      ),
    );
  }

  Card cardBeneficiary(List<Beneficiary> beneficiaries, int index) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              imageProfileBeneficiary(),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      beneficiaries[index].code,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: secondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        '${beneficiaries[index].name} ${beneficiaries[index].lastName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageProfileBeneficiary() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(55.0),
          gradient: LinearGradient(
            colors: [primary.withOpacity(0.1), secondary.withOpacity(0.3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: Image.asset('assets/hombre.png', fit: BoxFit.cover),
        ),
      ),
    );
  }
}
