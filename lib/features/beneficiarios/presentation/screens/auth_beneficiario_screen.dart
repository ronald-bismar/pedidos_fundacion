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
import 'package:pedidos_fundacion/core/widgets/snackbar.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/core/widgets/textfield.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';
import 'package:pedidos_fundacion/features/beneficiarios/presentation/providers/register_beneficiary_notifier.dart';
import 'package:pedidos_fundacion/features/beneficiarios/presentation/screens/location_phone_register_screen.dart';
import 'package:pedidos_fundacion/features/beneficiarios/presentation/states/register_beneficiary_state.dart';
import 'package:pedidos_fundacion/features/beneficiarios/usecases/obtener_codigo_beneficiario.dart';
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
  late Beneficiary beneficiary;
  DateTime? birthdate;
  String socialReassonSelected = '';
  bool isLoading = false;

  final String messageError =
      'No se pudo generar el codigo BO para el beneficiario, intentelo de nuevo y verifique su señal de internet. ';

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
    _gettingCodeBeneficiary(context);

    ref.listen<RegisterBeneficiaryState>(registerBeneficiaryProvider, (
      previous,
      next,
    ) {
      if (next is RegisterSuccess) {
        beneficiary = beneficiary.copyWith(id: next.data);

        cambiarPantallaConNuevaPila(
          context,
          LocationPhoneAuthScreen(beneficiary),
        );
      } else if (next is RegisterFailure) {
        MySnackBar.error(context, next.error);
      }
    });

    final registerState = ref.watch(registerBeneficiaryProvider);

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
                        readOnly: true,
                        highlight: true,
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
                            setState(() => socialReassonSelected = value),
                      ),
                    ],
                  ),
                ),
                _buildRegisterButton(),
              ],
            ),
            if (isLoading || registerState is RegisterLoading)
              const LoadingIndicator(),
          ],
        ),
      ),
    );
  }

  void _gettingCodeBeneficiary(BuildContext context) {
    final codeAsync = ref.watch(getCodeBeneficiaryProvider);

    codeAsync.when(
      data: (code) {
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (code == null) {
            MySnackBar.info(context, messageError);
          } else {
            codigoController.text = code;
          }
        });
        return const SizedBox.shrink();
      },
      error: (error, _) {
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          MySnackBar.info(context, "$messageError, Error: $error");
          volverAnteriorPantalla(context);
        });
        return const SizedBox.shrink();
      },
      loading: () {
        isLoading = true;
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildRegisterButton() {
    return BotonAncho(
      text: "Siguiente",
      onPressed: () => _handleRegister(),
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

    if (birthdate == null) {
      MySnackBar.warning(context, 'Solicite la fecha de nacimiento');
      return;
    }

    beneficiary = Beneficiary(
      code: codigoController.text.trim(),
      dni: cedulaController.text.trim(),
      name: nombreController.text.trim(),
      lastName: apellidoController.text.trim(),
      birthdate: birthdate!,
      socialReasson: socialReassonSelected,
      active: true,
    );

    ref
        .read(registerBeneficiaryProvider.notifier)
        .registerUser(beneficiary: beneficiary);
  }
}
