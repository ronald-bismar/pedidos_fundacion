import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/background.dart';
import 'package:pedidos_fundacion/core/widgets/boton_ancho.dart';
import 'package:pedidos_fundacion/core/widgets/progress_indicator.dart';
import 'package:pedidos_fundacion/core/widgets/snackbar.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/core/widgets/textfield.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';
import 'package:pedidos_fundacion/domain/entities/programa.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/providers/user_to_register_notifier.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/presentation/providers/grupo_beneficiario_notifier.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/presentation/screens/image_profile_beneficiario_screen.dart';

class GroupAssignedScreen extends ConsumerStatefulWidget {
  final String beneficiaryId;
  const GroupAssignedScreen({super.key, required this.beneficiaryId});

  @override
  ConsumerState<GroupAssignedScreen> createState() =>
      _GenerateUserPasswordScreenState();
}

class _GenerateUserPasswordScreenState
    extends ConsumerState<GroupAssignedScreen> {
  late TextEditingController groupAssignedController;
  late TextEditingController contrasenaController;
  bool isSuccess = true;
  String beneficiaryName = '';
  String codeBeneficiary = '';
  String nameGroup = '';

  @override
  void initState() {
    super.initState();
    groupAssignedController = TextEditingController();
    contrasenaController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<Beneficiary?>>(
      beneficiaryStreamProvider(widget.beneficiaryId),
      (previous, next) {
        next.whenData((beneficiary) {
          if (beneficiary != null) {
            beneficiaryName = '${beneficiary.name} ${beneficiary.lastName}';
            codeBeneficiary = beneficiary.code;
          }
        });

        if (next.hasError) {
          isSuccess = false;
          MySnackBar.error(context, 'No se pudo obtener al beneficiario.');
        }
      },
    );

    final coordinatorAsyncValue = ref.watch(
      coordinatorStreamProvider(widget.beneficiaryId),
    );
    ref.listen<AsyncValue<Group?>>(
      beneficiaryGroupAssignedStreamProvider(widget.beneficiaryId),
      (previous, next) {
        next.whenData((group) {
          if (group != null) {
            groupAssignedController.text =
                '${group.groupName} (${group.ageRange.toString()})';
          }
        });

        if (next.hasError) {
          isSuccess = false;
          MySnackBar.error(
            context,
            'No se pudo obtener el grupo asignado al beneficiario.',
          );
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
                    subTitle('Nombre: $beneficiaryName', textColor: dark),
                    subTitle('Codigo: $codeBeneficiary', textColor: dark),
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
                        'El beneficiario sera asignado al grupo “Triunfadores” (edad entre 5 y 8 años)',
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
                  readOnly: isSuccess,
                ),
                Column(
                  children: [
                    BotonAncho(
                      text: "Aceptar",
                      onPressed: () => cambiarPantalla(
                        context,
                        ImageProfileBeneficiaryScreen(),
                      ),

                      marginVertical: 0,
                      backgroundColor: white,
                      textColor: dark,
                      paddingHorizontal: 60,
                    ),
                    SizedBox(height: 10),
                    BotonAncho(
                      text: "Cambiar grupo",
                      onPressed: () async {
                        if (isSuccess) {
                          cambiarPantalla(
                            context,
                            ImageProfileBeneficiaryScreen(),
                          );
                        }
                      },
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
            if (coordinatorAsyncValue.isLoading) LoadingIndicator(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    groupAssignedController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }
}
