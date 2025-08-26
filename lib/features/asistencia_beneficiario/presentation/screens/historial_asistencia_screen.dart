import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/widgets/drop_down_options.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/core/widgets/text_normal.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';
import 'package:pedidos_fundacion/domain/entities/programa.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/presentation/widgets/card_historial_asistencia_beneficiario.dart';
import 'package:pedidos_fundacion/features/beneficiarios/presentation/providers/beneficiaries_provider.dart';
import 'package:pedidos_fundacion/features/beneficiarios/presentation/providers/grupos_provider.dart';

class AttendanceHistoryBeneficiaryScreen extends ConsumerStatefulWidget {
  final String attendanceId;

  const AttendanceHistoryBeneficiaryScreen({
    super.key,
    required this.attendanceId,
  });

  @override
  ConsumerState<AttendanceHistoryBeneficiaryScreen> createState() =>
      _AttendanceHistoryBeneficiaryScreenState();
}

class _AttendanceHistoryBeneficiaryScreenState
    extends ConsumerState<AttendanceHistoryBeneficiaryScreen> {
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 5),

                title('Historial de Asistencias'),

                const SizedBox(height: 15),
                DropDownOptions(
                  itemInitial:
                      selectedGroup?.groupName ?? 'Selecciona un grupo',
                  onSelect: (value) => _onGroupSelected(value, groups),
                  items: groups
                      .map((group) => '${group.groupName} ${group.ageRange}')
                      .toList(),
                ),
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
                                  subTitle('Marzo 2025', textColor: dark),
                                  const SizedBox(height: 4),
                                  textNormal(
                                    'Beneficiarios registrados: 100',
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
                              final beneficiariesAsyncValue = ref.watch(
                                beneficiariesStreamProvider(
                                  selectedGroup?.id ?? '',
                                ),
                              );

                              return beneficiariesAsyncValue.when(
                                loading: () => _loadingState(),
                                error: (error, stackTrace) =>
                                    _errorState(error),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onGroupSelected(String groupDisplayName, List<Group> groups) {
    final Group foundGroup = groups.firstWhere(
      (group) => '${group.groupName} ${group.ageRange}' == groupDisplayName,
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
    return ListView.builder(
      itemCount: beneficiaries.length,
      itemBuilder: (context, index) {
        return CardHistoryAttendanceBeneficiary(beneficiaries[index]);
      },
    );
  }
}
