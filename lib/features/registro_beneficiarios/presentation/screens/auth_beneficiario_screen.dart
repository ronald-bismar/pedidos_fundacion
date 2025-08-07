import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/autocomplete_textfield.dart';
import 'package:pedidos_fundacion/core/widgets/background.dart';
import 'package:pedidos_fundacion/core/widgets/boton_ancho.dart';
import 'package:pedidos_fundacion/core/widgets/date_picker_textfield.dart';
import 'package:pedidos_fundacion/core/widgets/logo.dart';
import 'package:pedidos_fundacion/core/widgets/progress_indicator.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/core/widgets/textfield.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/providers/register_notifier.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/states/register_state.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/presentation/screens/location_phone_register_screen.dart';
import 'package:pedidos_fundacion/toDataDynamic/social_reassons.dart';

class AuthBeneficiaryScreen extends ConsumerStatefulWidget {
  const AuthBeneficiaryScreen({super.key});

  @override
  ConsumerState<AuthBeneficiaryScreen> createState() =>
      _AuthBeneficiaryScreenState();
}

class _AuthBeneficiaryScreenState extends ConsumerState<AuthBeneficiaryScreen> {
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  DateTime? birthdate;
  String socialReasson = '';

  @override
  void dispose() {
    codigoController.dispose();
    cedulaController.dispose();
    nombreController.dispose();
    apellidoController.dispose();
    telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ref.listen<RegisterState>(registerProvider, (previous, next) {
    //   if (next is RegisterSuccess) {
    //     coordinator = coordinator.copyWith(id: next.data);

    //     cambiarPantallaConNuevaPila(
    //       context,
    //       LocationPostScreen(coordinator: coordinator),
    //     );
    //   } else if (next is RegisterFailure) {
    //     MySnackBar.error(context, next.error);
    //   }
    // });

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
                    title('REGISTRO DE BENEFICIARIOS'),
                    subTitle(
                      'Solicite sus datos al beneficiario',
                      textColor: dark,
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      TextFieldCustom(
                        label: "Codigo",
                        controller: codigoController,
                        marginVertical: 8,
                        prefixIcon: Icons.account_box_outlined,
                      ),
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

                      DatePickerTextField(
                        label: "Fecha de nacimiento",
                        controller: birthDateController,
                        marginVertical: 8,
                        onDateSelected: (newDate) => birthdate = newDate,
                      ),

                      AutoCompleteTextField(
                        label: "Razon Social",
                        autocompleteOptions: socialReassons,
                        prefixIcon: Icons.volunteer_activism,
                        textInputType: TextInputType.emailAddress,
                        marginVertical: 8,
                        onChanged: (value) =>
                            setState(() => socialReasson = value),
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
      onPressed: () =>
          cambiarPantallaConNuevaPila(context, LocationPhoneAuthScreen()),
      // _handleRegister,
      marginVertical: 0,
      backgroundColor: white,
      textColor: dark,
      paddingHorizontal: 60,
    );
  }

  void _handleRegister() {
    // Cerrar el teclado si está abierto
    FocusScope.of(context).unfocus();

    // // Validaciones básicas
    // coordinator = Coordinator(
    //   dni: cedulaController.text.trim(),
    //   name: nombreController.text.trim(),
    //   lastName: apellidoController.text.trim(),
    //   email: emailController.text.trim(),
    //   role: cargoSelected,
    //   profession: profesionController.text.trim(),
    //   active: false,
    // );

    // ref.read(registerProvider.notifier).registerUser(coordinator: coordinator);
  }
}
