import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/alert_dialog_options.dart';
import 'package:pedidos_fundacion/core/widgets/background.dart';
import 'package:pedidos_fundacion/core/widgets/boton_ancho.dart';
import 'package:pedidos_fundacion/core/widgets/logo.dart';
import 'package:pedidos_fundacion/core/widgets/progress_indicator.dart';
import 'package:pedidos_fundacion/core/widgets/snackbar.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/core/widgets/textfield.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/providers/register_notifier.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/screens/location_post_screen.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/states/register_state.dart';
import 'package:pedidos_fundacion/toDataDynamic/cargos.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController profesionController = TextEditingController();
  String cargoSelected = "";
  late Coordinator coordinator;

  @override
  void dispose() {
    cedulaController.dispose();
    nombreController.dispose();
    apellidoController.dispose();
    emailController.dispose();
    profesionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<RegisterState>(registerProvider, (previous, next) {
      if (next is RegisterSuccess) {
        coordinator = coordinator.copyWith(id: next.data);

        cambiarPantallaConNuevaPila(
          context,
          LocationPostScreen(coordinator: coordinator),
        );
      } else if (next is RegisterFailure) {
        MySnackBar.error(context, next.error);
      }
    });

    final registerState = ref.watch(registerProvider);

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
                    title('REGISTRO DE NUEVO USUARIO'),
                    subTitle(
                      'Solicite los datos al nuevo usuario',
                      textColor: dark,
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      TextFieldCustom(
                        label: "Cedula de identidad",
                        controller: cedulaController,
                        marginVertical: 8,
                        prefixIcon: Icons.badge,
                      ),
                      TextFieldCustom(
                        label: "Nombre",
                        controller: nombreController,
                        marginVertical: 8,
                        textCapitalization: TextCapitalization.words,
                        prefixIcon: Icons.person,
                        textInputType: TextInputType.name,
                      ),
                      TextFieldCustom(
                        label: "Apellidos",
                        controller: apellidoController,
                        marginVertical: 8,
                        textCapitalization: TextCapitalization.words,
                        prefixIcon: Icons.person_2_outlined,
                        textInputType: TextInputType.name,
                      ),
                      TextFieldCustom(
                        label: "Email",
                        controller: emailController,
                        prefixIcon: Icons.email,
                        textInputType: TextInputType.emailAddress,
                        marginVertical: 8,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        child: AlertDialogOptions(
                          titleAlertDialog: 'Cargo',
                          widthAlertDialog: double.infinity,
                          itemInitial: cargoSelected,
                          onSelect: (cargo) {
                            setState(() {
                              cargoSelected = cargo;
                            });
                          },
                          items: Role.values,
                          icon: Icons.admin_panel_settings,
                          messageInfo: 'Cargo',
                        ),
                      ),
                      TextFieldCustom(
                        label: "Profesión",
                        controller: profesionController,
                        prefixIcon: Icons.work,
                        textCapitalization: TextCapitalization.words,
                        textInputType: TextInputType.text,
                        marginVertical: 8,
                      ),
                    ],
                  ),
                ),
                _buildRegisterButton(),
              ],
            ),
            if (registerState is RegisterLoading) const LoadingIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return BotonAncho(
      text: "Siguiente",
      onPressed: _handleRegister,
      marginVertical: 0,
      backgroundColor: white,
      textColor: dark,
      paddingHorizontal: 60,
    );
  }

  void _handleRegister() {
    // Cerrar el teclado si está abierto
    FocusScope.of(context).unfocus();

    // Validaciones básicas
    coordinator = Coordinator(
      dni: cedulaController.text.trim(),
      name: nombreController.text.trim(),
      lastName: apellidoController.text.trim(),
      email: emailController.text.trim(),
      role: cargoSelected,
      profession: profesionController.text.trim(),
      active: false,
    );

    ref.read(registerProvider.notifier).registerUser(coordinator: coordinator);
  }
}
