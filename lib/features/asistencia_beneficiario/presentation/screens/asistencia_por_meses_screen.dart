import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/core/widgets/text_normal.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia_mensual.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/presentation/providers/asistencia_mensual_provider.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/presentation/screens/asistencia_grupo_mes_screen.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/presentation/screens/asistencia_screen.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/presentation/widgets/card_asistencia_mensual.dart';

class ListMonthlyAttendance extends ConsumerStatefulWidget {
  const ListMonthlyAttendance({super.key});

  @override
  ConsumerState<ListMonthlyAttendance> createState() =>
      _ListMonthlyAttendanceScreenState();
}

class _ListMonthlyAttendanceScreenState
    extends ConsumerState<ListMonthlyAttendance> {
  @override
  Widget build(BuildContext context) {
    final monthlyAttendanceAsyncValue = ref.watch(monthlyAttendanceProvider);

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,

        color: primary,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                title('Lista de Asistencias por Mes'),
                const SizedBox(height: 20),
                Expanded(
                  child: monthlyAttendanceAsyncValue.when(
                    loading: () => _loadingState(),

                    error: (error, stackTrace) => _errorState(error),

                    data: (monthlyAttendances) {
                      if (monthlyAttendances.isEmpty) {
                        return _emptyState();
                      }
                      return _loadedState(monthlyAttendances);
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
          cambiarPantalla(context, AttendanceBeneficiaryScreen());
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
          subTitle('Error al cargar asistencias', fontWeight: FontWeight.w600),
          const SizedBox(height: 8),
          textNormal(error.toString(), textColor: white.withOpacity(0.8)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Refrescar los datos
              ref.invalidate(monthlyAttendanceProvider);
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
          subTitle('No hay asistencias', fontWeight: FontWeight.w600),
          const SizedBox(height: 8),
          textNormal('Aún no se han registrado asistencias'),
        ],
      ),
    );
  }

  Widget _loadedState(List<MonthlyAttendance> attendances) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(monthlyAttendanceProvider);
      },
      child: ListView.builder(
        itemCount: attendances.length,
        itemBuilder: (context, index) {
          return CardMonthlyAttendance(
            attendances[index],
            onTap: () {
              cambiarPantalla(
                context,
                AttendanceGroupMonthScreen(
                  idMonthlyAttendance: attendances[index].id,
                  nameGroup: attendances[index].nameGroup,
                  month: attendances[index].month,
                  year: attendances[index].year,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
