import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/alert_dialog_options.dart';
import 'package:pedidos_fundacion/core/widgets/drop_down_options.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/core/widgets/text_normal.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia.dart';
import 'package:pedidos_fundacion/domain/entities/asistencia_beneficiario.dart';
import 'package:pedidos_fundacion/domain/entities/programa.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/model/estados_asistencia.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/presentation/providers/asistencia_beneficiario_provider.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/presentation/providers/register_attendance_provider.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/presentation/screens/asistencia_por_meses_screen.dart';
import 'package:pedidos_fundacion/features/asistencia_beneficiario/presentation/widgets/card_asistencia_beneficario.dart';
import 'package:pedidos_fundacion/features/beneficiarios/presentation/providers/beneficiaries_provider.dart';
import 'package:pedidos_fundacion/features/beneficiarios/presentation/providers/grupos_provider.dart';
import 'package:pedidos_fundacion/toDataDynamic/tipos_de_asistencia.dart';

class AttendanceBeneficiaryScreen extends ConsumerStatefulWidget {
  final String beneficiaryId;
  const AttendanceBeneficiaryScreen({this.beneficiaryId = '', super.key});

  @override
  ConsumerState<AttendanceBeneficiaryScreen> createState() =>
      _AttendanceBeneficiaryScreenState();
}

class _AttendanceBeneficiaryScreenState
    extends ConsumerState<AttendanceBeneficiaryScreen> {
  late Attendance attendance;
  List<AttendanceBeneficiary> attendanceList = [];
  String typeInitial = tiposDeAsistencia.first;
  bool showDropdown = true;
  final GlobalKey<DropDownOptionsState> dropDownKey =
      GlobalKey<DropDownOptionsState>();

  @override
  void initState() {
    super.initState();
    attendance = Attendance(type: typeInitial, date: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final selectedGroup = ref.watch(selectedGroupProvider);
    final List<Group> groups = ref
        .watch(groupsProvider)
        .maybeWhen(data: (data) => data, orElse: () => []);

    final DateTime today = DateTime.now();
    final String formattedDate = DateFormat('d MMMM y', 'es').format(today);

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    Expanded(
                      flex: 1,
                      child: Center(child: title('Asistencia')),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Agregamos esta línea
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.list_alt,
                              color: white,
                              size: 35,
                            ),
                            onPressed: () {
                              cambiarPantalla(context, ListMonthlyAttendance());
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.check_rounded,
                              color: white,
                              size: 35,
                            ),
                            onPressed: () {
                              _saveAttendance();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: AlertDialogOptions(
                    textAlignment: TextAlign.center,
                    backgroundColor: Colors.grey.shade300,
                    titleAlertDialog: 'Selecciona tipo de asistencia',
                    widthAlertDialog: 330,
                    itemInitial: typeInitial,
                    onSelect: (typeAttendance) {
                      setState(() {
                        attendance = attendance.copyWith(type: typeAttendance);
                      });
                    },
                    items: tiposDeAsistencia,
                    messageInfo: 'Tipo de asistencia',
                    textSize: 18,
                  ),
                ),
                const SizedBox(height: 15),
                DropDownOptions(
                  key: dropDownKey,
                  messageNotShow:
                      'Guarda primero la asistencia de este grupo para seleccionar otro',
                  itemInitial: 'Selecciona un grupo',
                  onSelect: (value) => {_onGroupSelected(value, groups)},
                  items: groups.map((group) => group.groupName).toList(),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        subTitle(formattedDate, textColor: dark),
                        const SizedBox(height: 16),
                        Expanded(
                          child: selectedGroup == null
                              ? _selectGroupMessage()
                              : Consumer(
                                  builder: (context, ref, child) {
                                    final attendanceBeneficiariesAsyncValue =
                                        ref.watch(
                                          attendanceBeneficiariesStreamProvider(
                                            (selectedGroup.id, attendance.date),
                                          ),
                                        );

                                    return attendanceBeneficiariesAsyncValue
                                        .when(
                                          loading: () => _loadingState(),
                                          error: (error, stackTrace) =>
                                              _errorState(error),
                                          data: (attendanceBeneficiaries) {
                                            attendanceList =
                                                attendanceBeneficiaries;
                                            if (attendanceBeneficiaries
                                                .isEmpty) {
                                              return _emptyState();
                                            }

                                            return _loadedState(attendanceList);
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

  Widget _selectGroupMessage() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group_outlined,
            size: 64,
            color: secondary.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          subTitle(
            'Selecciona un grupo',
            fontWeight: FontWeight.w600,
            textColor: dark,
          ),
        ],
      ),
    );
  }

  void _onGroupSelected(String groupDisplayName, List<Group> groups) {
    final Group foundGroup = groups.firstWhere(
      (group) => group.groupName == groupDisplayName,
      orElse: () => groups.first,
    );

    attendance = attendance.copyWith(
      idGroup: foundGroup.id,
      nameGroup: foundGroup.groupName,
    );
    ref.read(selectedGroupProvider.notifier).state = foundGroup;
  }

  // Helper method to save attendance and update group
  void _saveAttendance() async {
    if (attendanceList.isNotEmpty) {
      for (var attendance in attendanceList) {
        log('Attendance: ${attendance.toString()}');
      }

      if (attendanceList.isNotEmpty) {
        attendance = attendance.copyWith(id: attendanceList.first.idAttendance);
        await ref
            .watch(registerAttendanceProvider)
            .call(attendance, attendanceList, context);

        dropDownKey.currentState?.enableDropDown(true);
      } else {
        dropDownKey.currentState?.enableDropDown(true);
      }
    }
  }

  Widget _loadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(secondary),
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
          textNormal(error.toString(), textColor: secondary),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.invalidate(beneficiariesStreamProvider);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: secondary,
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
            Icons.people_outline,
            size: 64,
            color: secondary.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          subTitle(
            'No hay beneficiarios',
            fontWeight: FontWeight.w600,
            textColor: dark,
          ),
          const SizedBox(height: 8),
          textNormal(
            'Aún no se han registrado beneficiarios en este grupo',
            textColor: dark,
          ),
        ],
      ),
    );
  }

  Widget _loadedState(List<AttendanceBeneficiary> attendanceList) {
    return ListView(
      children: attendanceList
          .map(
            (attendance) => CardAttendanceBeneficiary(
              attendance,
              onAttendanceSelected: (value) {
                activeDropdown(attendanceList);
                setState(() {
                  attendance = attendance.copyWith(state: value.name);
                });
              },
            ),
          )
          .toList(),
    );
  }

  void activeDropdown(List<AttendanceBeneficiary> attendanceList) {
    if (attendanceList.any(
      (attendance) => attendance.state != StateAttendance.notRegistered.name,
    )) {
      dropDownKey.currentState?.enableDropDown(false);
    }
  }
}
