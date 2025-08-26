import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/core/widgets/text_normal.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia_beneficiario.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/presentation/widgets/card_historial_asistencia_beneficiario.dart';
import 'package:pedidos_fundacion/features/beneficiarios/presentation/providers/asistencia_por_grupo_provider.dart';
import 'package:pedidos_fundacion/features/beneficiarios/presentation/providers/beneficiaries_provider.dart';

class AttendanceGroupMonthScreen extends ConsumerStatefulWidget {
  final String idAttendance;
  final String nameGroup;
  final DateTime date;

  const AttendanceGroupMonthScreen({
    super.key,
    required this.idAttendance,
    required this.nameGroup,
    required this.date,
  });

  @override
  ConsumerState<AttendanceGroupMonthScreen> createState() =>
      _AttendanceGroupMonthScreenState();
}

class _AttendanceGroupMonthScreenState
    extends ConsumerState<AttendanceGroupMonthScreen> {
  int cantAttendances = 0;
  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat(
      "MMMM 'de' y",
      'es_ES',
    ).format(widget.date);

    formattedDate = formattedDate[0].toUpperCase() + formattedDate.substring(1);

    return Scaffold(
      body: Container(
        color: primary,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 5),

                title('Historial de Asistencias'),
                const SizedBox(height: 15),
                title(widget.nameGroup),
                const SizedBox(height: 15),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  subTitle(formattedDate, textColor: dark),
                                  const SizedBox(height: 4),
                                  textNormal(
                                    'Beneficiarios registrados: $cantAttendances',
                                    textAlign: TextAlign.left,
                                    textColor: dark.withAlpha(200),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.calendar_month,
                                  color: secondary,
                                ),
                              ),
                            ),
                          ],
                        ),

                        Expanded(
                          child: Consumer(
                            builder: (context, ref, child) {
                              final attendancesAsyncValue = ref.watch(
                                attendanceGroupStreamProvider(
                                  widget.idAttendance,
                                ),
                              );

                              return attendancesAsyncValue.when(
                                loading: () => _loadingState(),
                                error: (error, stackTrace) =>
                                    _errorState(error),
                                data: (attendances) {
                                  cantAttendances = attendances.length;
                                  if (attendances.isEmpty) {
                                    return _emptyState();
                                  }

                                  return _loadedState(attendances);
                                },
                              );
                            },
                          ),
                        ),
                      ],
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

  Widget _loadedState(List<AttendanceBeneficiary> attendances) {
    Map<String, List<AttendanceBeneficiary>> groupedAttendances = {};

    for (var attendance in attendances) {
      if (groupedAttendances.containsKey(attendance.idBeneficiary)) {
        groupedAttendances[attendance.idBeneficiary]!.add(attendance);
      } else {
        groupedAttendances[attendance.idBeneficiary] = [attendance];
      }
    }

    List<MapEntry<String, List<AttendanceBeneficiary>>> beneficiaries =
        groupedAttendances.entries.toList();

    return ListView.builder(
      itemCount: beneficiaries.length,
      itemBuilder: (context, index) {
        var beneficiaryEntry = beneficiaries[index];
        String beneficiaryName = beneficiaryEntry.value.first.nameBeneficiary;
        List<AttendanceBeneficiary> beneficiaryAttendances =
            beneficiaryEntry.value;

        return CardHistoryAttendanceBeneficiary(
          beneficiaryName,
          beneficiaryAttendances,
        );
      },
    );
  }
}
