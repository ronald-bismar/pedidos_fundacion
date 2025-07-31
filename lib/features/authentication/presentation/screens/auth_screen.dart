import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/constants/cargos.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/boton_ancho.dart';
import 'package:pedidos_fundacion/core/widgets/background.dart';
import 'package:pedidos_fundacion/core/widgets/logo.dart';
import 'package:pedidos_fundacion/core/widgets/alert_dialog_options.dart';
import 'package:pedidos_fundacion/core/widgets/textfield.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/providers/register_notifier.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/providers/register_state.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/screens/location_post_screen.dart';

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
    // Escuchar los cambios de estado
    ref.listen<RegisterState>(registerProvider, (previous, next) {
      if (next is RegisterSuccess) {
        // Mostrar mensaje de éxito y navegar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: Colors.green),
        );
        cambiarPantalla(context, LocationPostScreen());
      } else if (next is RegisterFailure) {
        // Mostrar mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error), backgroundColor: Colors.red),
        );
      }
    });

    final registerState = ref.watch(registerProvider);

    if (registerState is RegisterLoading) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 60),
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(white),
        ),
      );
    }

    return backgroundScreen(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Logo(),
                title('REGISTRO DE USUARIO'),
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
                        prefixIcon: Icons.person,
                        textInputType: TextInputType.name,
                      ),
                      TextFieldCustom(
                        label: "Apellidos",
                        controller: apellidoController,
                        prefixIcon: Icons.person_2_outlined,
                        textInputType: TextInputType.name,
                        marginVertical: 8,
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
                          items: Cargo.values,
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
            if (registerState is RegisterLoading)
              Container(
                color: Colors.black54,
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(white),
                ),
              ),
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
    // Validaciones básicas
    if (_validateForm()) {
      final coordinator = Coordinator(
        id: '',
        dni: cedulaController.text.trim(),
        name: nombreController.text.trim(),
        lastName: apellidoController.text.trim(),
        email: emailController.text.trim(),
        role: cargoSelected,
        profession: profesionController.text.trim(),
      );

      // Llamar al método del notifier
      ref
          .read(registerProvider.notifier)
          .registerUser(coordinator: coordinator);
    }
  }

  bool _validateForm() {
    if (cedulaController.text.trim().isEmpty) {
      _showErrorMessage('Por favor ingresa tu cédula de identidad');
      return false;
    }
    if (nombreController.text.trim().isEmpty) {
      _showErrorMessage('Por favor ingresa tu nombre');
      return false;
    }
    if (apellidoController.text.trim().isEmpty) {
      _showErrorMessage('Por favor ingresa tus apellidos');
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      _showErrorMessage('Por favor ingresa tu email');
      return false;
    }
    if (cargoSelected.isEmpty) {
      _showErrorMessage('Por favor selecciona un cargo');
      return false;
    }
    if (profesionController.text.trim().isEmpty) {
      _showErrorMessage('Por favor ingresa tu profesión');
      return false;
    }
    return true;
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
