import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/boton_normal.dart';
import 'package:pedidos_fundacion/core/widgets/selection_dialog.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/core/widgets/text_normal.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/features/encargados/presentation/providers/encargados_provider.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/entrega.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/tipos_de_entregas.dart';
import 'package:pedidos_fundacion/features/entregas/presentation/providers/entregas_provider.dart';
import 'package:pedidos_fundacion/features/entregas/presentation/screens/datos_de_entrega.dart';
import 'package:pedidos_fundacion/features/entregas/presentation/screens/lista_entregas_beneficiarios_screen.dart';
import 'package:pedidos_fundacion/features/entregas/presentation/widgets/card_entrega.dart';

class ListDeliveriesScreen extends ConsumerStatefulWidget {
  const ListDeliveriesScreen({super.key});

  @override
  ConsumerState<ListDeliveriesScreen> createState() =>
      _ListDeliveriesScreenState();
}

class _ListDeliveriesScreenState extends ConsumerState<ListDeliveriesScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final deliveriesAsyncValue = ref.watch(deliveriesProvider);

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
                title('Entregas'),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: BotonNormal(
                      onPressed: () {
                        _showSelectionDialog();
                      },
                      label: 'Nueva Entrega',
                      textColor: white,
                      buttonColor: secondary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: deliveriesAsyncValue.when(
                    loading: () => _loadingState(),

                    error: (error, stackTrace) => _errorState(error),

                    data: (deliveries) {
                      if (deliveries.isEmpty) {
                        return _emptyState();
                      }
                      return _loadedState(deliveries);
                    },
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
          subTitle('Error al cargar entregas', fontWeight: FontWeight.w600),
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
          subTitle('No hay entregas', fontWeight: FontWeight.w600),
          const SizedBox(height: 8),
          textNormal('Aún no se han registrado entregas'),
        ],
      ),
    );
  }

  Widget _loadedState(List<Delivery> deliveries) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(coordinatorsProvider);
      },
      child: ListView.builder(
        itemCount: deliveries.length,
        itemBuilder: (context, index) {
          return CardDelivery(
            deliveries[index],
            onTap: () {
              cambiarPantalla(
                context,
                ListDeliveriesBeneficiaryScreen(deliveries[index]),
              );
            },
          );
        },
      ),
    );
  }

  void _showSelectionDialog() {
    _controller.forward(from: 0.0);

    SelectionDialog.show(
      context: context,
      items: TypesOfDeliveries.values,
      icon: Icons.group,
      titleAlertDialog: 'Nueva Entrega',
      onSelect: (String typeDelivery) {
        cambiarPantalla(context, DataDeliveryScreen(typeDelivery));
      },
    ).then((_) {
      // Solo animar la flecha de vuelta
      _controller.reverse();
    });
  }
}
