import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/background.dart';
import 'package:pedidos_fundacion/core/widgets/boton_ancho.dart';
import 'package:pedidos_fundacion/core/widgets/progress_indicator.dart';
import 'package:pedidos_fundacion/core/widgets/selection_dialog.dart';
import 'package:pedidos_fundacion/core/widgets/snackbar.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/core/widgets/textfield.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';
import 'package:pedidos_fundacion/domain/entities/programa.dart';
import 'package:pedidos_fundacion/domain/entities/rango_edad.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/presentation/providers/actualizar_grupo_beneficiario.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/presentation/providers/grUpo_beneficiario_notifier.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/presentation/screens/image_profile_beneficiario_screen.dart';

class GroupAssignedScreen extends ConsumerStatefulWidget {
  final String beneficiaryId;
  final String idGroup;
  const GroupAssignedScreen({
    super.key,
    required this.beneficiaryId,
    required this.idGroup,
  });

  @override
  ConsumerState<GroupAssignedScreen> createState() =>
      _GenerateUserPasswordScreenState();
}

class _GenerateUserPasswordScreenState
    extends ConsumerState<GroupAssignedScreen>
    with TickerProviderStateMixin {
  late TextEditingController groupAssignedController;
  late Beneficiary beneficiary;
  late Group group;
  List<Group> groups = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    groupAssignedController = TextEditingController();

    initGroupBeneficiaryEmpty();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controller.forward();
  }

  void initGroupBeneficiaryEmpty() {
    beneficiary = Beneficiary(birthdate: DateTime.now());
    group = Group(ageRange: AgeRange(0, 0));
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(
      beneficiaryWithGroupProvider(widget.beneficiaryId),
    );

    ref.listen<AsyncValue<BeneficiaryWithGroup?>>(
      beneficiaryWithGroupProvider(widget.beneficiaryId),
      (previous, next) {
        next.whenData((data) {
          if (data != null) {
            if (data.beneficiary == null) {
              MySnackBar.error(context, 'No se pudo obtener al beneficiario.');
            } else {
              beneficiary = data.beneficiary!;
            }
            if (data.group == null) {
              MySnackBar.error(
                context,
                'No se pudo obtener el grupo del beneficiario.',
              );
            } else {
              group = data.group!;
              groupAssignedController.text =
                  '${group.groupName} (${group.ageRange.toString()})';
            }

            if (data.groups.isEmpty) {
              MySnackBar.error(
                context,
                'No se pudo obtener los grupos opcionales.',
              );
            } else {
              groups = data.groups;
            }
          }
        });

        if (next.hasError) {
          MySnackBar.error(context, 'No se pudo obtener al beneficiario.');
        }
      },
    );

    return backgroundScreen(
      SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    subTitle('Codigo: ${beneficiary.code}', textColor: dark),

                    subTitle(
                      'Nombre: ${beneficiary.name} ${beneficiary.lastName}',
                      textColor: dark,
                    ),
                    subTitle('Edad: ${beneficiary.age} años', textColor: dark),
                  ],
                ),
                Column(
                  children: [
                    title('Grupo Asignado'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 10,
                      ),
                      child: subTitle(
                        'El beneficiario sera asignado al grupo “${group.groupName}" (${group.ageRange.toString()})',
                        textColor: dark,
                      ),
                    ),
                  ],
                ),
                TextFieldCustom(
                  label: "",
                  controller: groupAssignedController,
                  prefixIcon: Icons.group,
                  textInputType: TextInputType.text,
                  marginVertical: 8,
                  readOnly: true,
                ),
                Column(
                  children: [
                    BotonAncho(
                      text: "Aceptar",
                      onPressed: () => _handleSave(),
                      marginVertical: 0,
                      backgroundColor: white,
                      textColor: dark,
                      paddingHorizontal: 60,
                    ),
                    SizedBox(height: 10),
                    BotonAncho(
                      text: "Cambiar grupo",
                      onPressed: () => _showSelectionDialog(),
                      marginVertical: 0,
                      marginHorizontal: 0,
                      backgroundColor: secondary,
                      textColor: white,
                      paddingHorizontal: 20,
                    ),
                  ],
                ),
              ],
            ),
            if (result.isLoading) LoadingIndicator(),
          ],
        ),
      ),
    );
  }

  void _showSelectionDialog() {
    _controller.forward(from: 0.0);

    SelectionDialog.show(
      context: context,
      items: groups.map((group) => group.groupName).toList(),
      icon: Icons.group,
      titleAlertDialog: 'Programa/Grupo',
      onSelect: (String newGroup) {
        assignNewGroup(newGroup);
      },
    ).then((_) {
      // Solo animar la flecha de vuelta
      _controller.reverse();
    });
  }

  void assignNewGroup(String newGroup) {
    final groupObject = groups.firstWhere((g) => g.groupName == newGroup);
    group = groupObject;
    groupAssignedController.text =
        '${group.groupName} (${group.ageRange.toString()})';

    verifyAgeOrShowWarning(beneficiary.age, groupObject.ageRange);

    setState(() {});
  }

  void verifyAgeOrShowWarning(int age, AgeRange ageRange) {
    final validateAgeInRange = AgeRange.validateAgeInRange(age, ageRange);
    if (!validateAgeInRange.isValid) {
      MySnackBar.warning(context, validateAgeInRange.mensaje);
    }
  }

  void _handleSave() {
    if (group.id != beneficiary.idGroup) {
      final updateGroupBeneficiary = ref.watch(updateGroupBeneficiaryProvider);
      updateGroupBeneficiary(beneficiary, group.id);
    }

    cambiarPantallaConNuevaPila(context, ImageProfileBeneficiaryScreen(beneficiary));
  }

  @override
  void dispose() {
    groupAssignedController.dispose();
    super.dispose();
  }
}
