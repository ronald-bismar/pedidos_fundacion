import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/autocomplete_textfield.dart';
import 'package:pedidos_fundacion/core/widgets/background.dart';
import 'package:pedidos_fundacion/core/widgets/boton_ancho.dart';
import 'package:pedidos_fundacion/core/widgets/logo.dart';
import 'package:pedidos_fundacion/core/widgets/progress_indicator.dart';
import 'package:pedidos_fundacion/core/widgets/snackbar.dart';
import 'package:pedidos_fundacion/core/widgets/textfield.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/presentation/providers/register_phone_location_notifier.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/presentation/screens/grupo_asignado_screen.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/presentation/states/register_beneficiary_state.dart';
import 'package:pedidos_fundacion/toDataDynamic/places.dart';

class LocationPhoneAuthScreen extends ConsumerStatefulWidget {
  final Beneficiary beneficiary;
  const LocationPhoneAuthScreen(this.beneficiary, {super.key});

  @override
  ConsumerState<LocationPhoneAuthScreen> createState() =>
      _LocationPhoneAuthScreenState();
}

class _LocationPhoneAuthScreenState
    extends ConsumerState<LocationPhoneAuthScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String region = '';
  bool checkedAddress = false;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<RegisterBeneficiaryState>(
      registerPhoneLocationBeneficiaryProvider,
      (previous, next) {
        if (next is RegisterSuccess) {
          cambiarPantallaConNuevaPila(
            context,
            GroupAssignedScreen(
              beneficiaryId: widget.beneficiary.id,
              idGroup: widget.beneficiary.idGroup,
            ),
          );
        } else if (next is RegisterFailure) {
          MySnackBar.error(context, next.error);
        }
      },
    );

    final registerState = ref.watch(registerPhoneLocationBeneficiaryProvider);

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
                Column(children: [title('COMPLETE EL REGISTRO')]),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      TextFieldCustom(
                        label: "Telefono (opcional)",
                        controller: phoneController,
                        prefixIcon: Icons.phone,
                        textCapitalization: TextCapitalization.words,
                        textInputType: TextInputType.text,
                        marginVertical: 8,
                      ),

                      AutoCompleteTextField(
                        label: "Provincia/Comunidad",
                        autocompleteOptions: places,
                        prefixIcon: Icons.map_outlined,
                        textInputType: TextInputType.name,
                        marginVertical: 8,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (value) => setState(() => region = value),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CheckboxListTile(
                          title: const Text("Tiene zona, calle o nro de casa?"),
                          value: checkedAddress,
                          onChanged: (value) {
                            setState(() {
                              checkedAddress = value ?? false;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.trailing,
                          activeColor: secondary,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) => SizeTransition(
                          sizeFactor: animation,
                          axis: Axis.vertical,
                          child: child,
                        ),
                        child: checkedAddress
                            ? TextFieldCustom(
                                key: const ValueKey('direccion'),
                                label: "Dirección",
                                controller: addressController,
                                marginVertical: 8,
                                textCapitalization: TextCapitalization.words,
                                prefixIcon: Icons.location_on_outlined,
                                textInputType: TextInputType.name,
                              )
                            : const SizedBox.shrink(key: ValueKey('vacio')),
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
      onPressed: () => _handleRegister(),
      marginVertical: 0,
      backgroundColor: white,
      textColor: dark,
      paddingHorizontal: 60,
    );
  }

  void _handleRegister() {
    // Cerrar el teclado si está abierto
    FocusScope.of(context).unfocus();

    final addressFilledIncorrect =
        checkedAddress && addressController.text.trim().isEmpty;

    if (addressFilledIncorrect) {
      MySnackBar.error(
        context,
        'Por favor introduzca una dirección, caso contrario desmarque el check',
      );
      return;
    }

    final beneficiary = widget.beneficiary.copyWith(
      phone: phoneController.text,
      location: checkedAddress ? '$region, ${addressController.text}' : region,
    );

    ref
        .read(registerPhoneLocationBeneficiaryProvider.notifier)
        .registerPhoneLocation(
          beneficiary: beneficiary,
          phone: phoneController.text.trim(),
          region: region,
          address: addressController.text.trim(),
        );
  }
}
