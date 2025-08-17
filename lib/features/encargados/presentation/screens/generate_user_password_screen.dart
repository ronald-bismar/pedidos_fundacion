import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/background.dart';
import 'package:pedidos_fundacion/core/widgets/boton_ancho.dart';
import 'package:pedidos_fundacion/core/widgets/logo.dart';
import 'package:pedidos_fundacion/core/widgets/progress_indicator.dart';
import 'package:pedidos_fundacion/core/widgets/snackbar.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/core/widgets/textfield.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/core/widgets/toast.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';
import 'package:pedidos_fundacion/features/encargados/presentation/providers/user_to_register_notifier.dart';
import 'package:pedidos_fundacion/features/login/presentation/screens/menu_screen.dart';

class GenerateUserPasswordScreen extends ConsumerStatefulWidget {
  final String coordinatorId;
  const GenerateUserPasswordScreen({super.key, required this.coordinatorId});

  @override
  ConsumerState<GenerateUserPasswordScreen> createState() =>
      _GenerateUserPasswordScreenState();
}

class _GenerateUserPasswordScreenState
    extends ConsumerState<GenerateUserPasswordScreen> {
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
                const Logo(),
                Column(
                  children: [
                    title('USUARIO Y CONTRASEÑA'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 10,
                      ),
                      child: subTitle(
                        'Usuario y contraseña para el acceso a la aplicación',
                        textColor: dark,
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      TextFieldCustom(
                        label: "",
                        controller: usuarioController,
                        prefixIcon: Icons.person,
                        textInputType: TextInputType.emailAddress,
                        marginVertical: 8,
                        readOnly: isSuccess,
                      ),
                      TextFieldCustom(
                        label: "",
                        controller: contrasenaController,
                        prefixIcon: Icons.lock,
                        textInputType: TextInputType.visiblePassword,
                        marginVertical: 8,
                        readOnly: isSuccess,
                      ),
                    ],
                  ),
                ),

                // textNormal(
                //   "Se enviará un correo electrónico de confirmación ${emailCoordinator.isEmpty ? "al usuario" : "a $emailCoordinator"} con los datos de acceso.",
                //   textColor: dark,
                // ),
                BotonAncho(
                  // text: "Enviar email de confirmación",
                  text: "Terminar registro",
                  onPressed: () async {
                    if (isSuccess) {
                      MyToast.showToast('Volviendo al menú principal');
                      cambiarPantalla(context, MenuScreen());
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
