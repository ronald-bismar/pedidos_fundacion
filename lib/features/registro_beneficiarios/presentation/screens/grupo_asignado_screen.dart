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
import 'package:pedidos_fundacion/domain/entities/encargado.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/providers/user_to_register_notifier.dart';
import 'package:pedidos_fundacion/features/login/presentation/widgets/image_user_profile.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/presentation/screens/image_profile_beneficiario_screen.dart';

class GroupAssignedScreen extends ConsumerStatefulWidget {
  final String coordinatorId;
  const GroupAssignedScreen({super.key, this.coordinatorId = ''});

  @override
  ConsumerState<GroupAssignedScreen> createState() =>
      _GenerateUserPasswordScreenState();
}

class _GenerateUserPasswordScreenState
    extends ConsumerState<GroupAssignedScreen> {
  late TextEditingController usuarioController;
  late TextEditingController contrasenaController;
  bool isSuccess = true;
  String emailCoordinator = "";

  @override
  void initState() {
    super.initState();
    usuarioController = TextEditingController();
    contrasenaController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<
      AsyncValue<Coordinator?>
    >(coordinatorStreamProvider(widget.coordinatorId), (previous, next) {
      next.whenData((coordinator) {
        if (coordinator != null) {
          emailCoordinator = coordinator.email;
          if (usuarioController.text != coordinator.username) {
            usuarioController.text = coordinator.username;
          }
          if (contrasenaController.text != coordinator.password) {
            contrasenaController.text = coordinator.password;
          }
        }
      });

      if (next.hasError) {
        isSuccess = false;
        MySnackBar.error(
          context,
          'No se pudo obtener el usuario y contraseña, por favor asigne un usuario y contraseña manualmente.',
        );
      }
    });

    final coordinatorAsyncValue = ref.watch(
      coordinatorStreamProvider(widget.coordinatorId),
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
                    subTitle('Nombre de beneficiario', textColor: dark),
                    subTitle('Codigo de beneficiario', textColor: dark),
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
                  controller: usuarioController,
                  prefixIcon: Icons.group,
                  textInputType: TextInputType.emailAddress,
                  marginVertical: 8,
                  readOnly: isSuccess,
                ),
                Column(
                  children: [
                    BotonAncho(
                      text: "Aceptar",
                      onPressed: () =>
                          cambiarPantalla(context, ImageProfileBeneficiaryScreen()),

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
                          cambiarPantalla(context, ImageProfileBeneficiaryScreen());
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
    usuarioController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }
}
