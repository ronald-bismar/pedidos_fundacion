import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/background.dart';
import 'package:pedidos_fundacion/core/widgets/boton_ancho.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/core/widgets/text_normal.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/domain/entities/programa.dart';
import 'package:pedidos_fundacion/features/entregas/presentation/providers/groups_provider.dart';
import 'package:pedidos_fundacion/features/entregas/presentation/screens/lista_entregas_screen.dart';

class SelectGroupsByDeliveryScreen extends ConsumerStatefulWidget {
  final String nameDelivery;
  final DateTime dateDelivery;
  const SelectGroupsByDeliveryScreen(
    this.nameDelivery,
    this.dateDelivery, {
    super.key,
  });

  @override
  ConsumerState<SelectGroupsByDeliveryScreen> createState() =>
      _SelectGroupsByDeliveryScreenState();
}

class _SelectGroupsByDeliveryScreenState
    extends ConsumerState<SelectGroupsByDeliveryScreen> {
  final List<Group> selectedGroups = [];

  @override
  Widget build(BuildContext context) {
    final groupsAsyncValue = ref.watch(groupsProvider);

    return backgroundScreen(
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: primary,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    title('Selecciona los grupos'),
                    const SizedBox(height: 20),
                    Expanded(
                      child: groupsAsyncValue.when(
                        loading: () => _loadingState(),
                        error: (error, stackTrace) => _errorState(error),
                        data: (groups) {
                          if (groups.isEmpty) {
                            return _emptyState();
                          }
                          return _loadedState(groups);
                        },
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: BotonAncho(
                      text: "Siguiente (${selectedGroups.length})",
                      onPressed: () {
                        if (selectedGroups.isEmpty) return;
                        _nextStep();
                      },
                      marginVertical: 0,
                      marginHorizontal: 0,
                      backgroundColor: selectedGroups.isEmpty
                          ? Colors.grey
                          : secondary,
                      textColor: white,
                      paddingHorizontal: 80,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
          subTitle('Error al cargar los grupos', fontWeight: FontWeight.w600),
          const SizedBox(height: 8),
          textNormal(error.toString(), textColor: white.withOpacity(0.8)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Refrescar los datos
              ref.invalidate(groupsProvider);
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
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group_outlined,
            size: 64,
            color: Colors.white.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          subTitle('No hay grupos', fontWeight: FontWeight.w600),
          const SizedBox(height: 8),
          textNormal('Aún no se han registrado grupos'),
        ],
      ),
    );
  }

  Widget _loadedState(List<Group> groups) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(groupsProvider);
      },
      child: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          return CardGroupByDelivery(
            groups[index],
            onSelectionChanged: (isSelected) {
              setState(() {
                removeAddGroupSelected(isSelected, groups, index);
              });
            },
          );
        },
      ),
    );
  }

  void removeAddGroupSelected(bool isSelected, List<Group> groups, int index) {
    if (isSelected) {
      selectedGroups.add(groups[index]);
    } else {
      selectedGroups.remove(groups[index]);
    }
  }

  void _nextStep() {
    if (selectedGroups.isEmpty) return;

    cambiarPantalla(context, ListDeliveriesScreen());
  }
}

// Card widget para mostrar grupos
class CardGroupByDelivery extends ConsumerStatefulWidget {
  final Group group;
  final Function(bool)? onSelectionChanged;

  const CardGroupByDelivery(this.group, {super.key, this.onSelectionChanged});

  @override
  ConsumerState<CardGroupByDelivery> createState() =>
      _CardGroupByDeliveryState();
}

class _CardGroupByDeliveryState extends ConsumerState<CardGroupByDelivery> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = false;
  }

  void _handleSelectionChange(bool? newValue) {
    setState(() {
      isSelected = newValue ?? false;
    });
    // Notificar al padre sobre el cambio
    widget.onSelectionChanged?.call(isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      color: isSelected ? quinary : null,
      child: InkWell(
        onTap: () {
          _handleSelectionChange(!isSelected);
        },
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subTitle(
                      widget.group.groupName,
                      fontWeight: FontWeight.w500,
                      textColor: dark,
                    ),
                    const SizedBox(height: 2),
                    textNormal(
                      'Rango de edad: ${widget.group.ageRange.minAge} - ${widget.group.ageRange.maxAge} años',
                      fontWeight: FontWeight.w400,
                      textColor: secondary,
                    ),
                    const SizedBox(height: 2),
                    textNormal(
                      'ID Coordinador: ${widget.group.idCoordinator}',
                      fontWeight: FontWeight.w400,
                      textColor: dark.withAlpha(150),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.group, color: secondary, size: 20),
              ),
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: isSelected,
                  onChanged: _handleSelectionChange,
                  activeColor: secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
