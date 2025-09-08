import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/background.dart';
import 'package:pedidos_fundacion/core/widgets/boton_ancho.dart';
import 'package:pedidos_fundacion/core/widgets/date_picker_textfield.dart';
import 'package:pedidos_fundacion/core/widgets/progress_indicator.dart';
import 'package:pedidos_fundacion/core/widgets/snackbar.dart';
import 'package:pedidos_fundacion/core/widgets/textfield.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/features/encargados/presentation/screens/welcome_screen.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/tipos_de_entregas.dart';
import 'package:pedidos_fundacion/features/entregas/presentation/screens/agregar_ayuda_economica_screen.dart';
import 'package:pedidos_fundacion/features/entregas/presentation/screens/pedidos_para_entrega_screen.dart';
import 'package:pedidos_fundacion/features/login/presentation/providers/login_notifier.dart';
import 'package:pedidos_fundacion/features/login/presentation/screens/menu_screen.dart';
import 'package:pedidos_fundacion/features/login/presentation/states/login_state.dart';
import 'package:pedidos_fundacion/presentation/user_application_provider.dart';

class DataDeliveryScreen extends ConsumerStatefulWidget {
  final String deliveryType;
  const DataDeliveryScreen(this.deliveryType, {super.key});

  @override
  ConsumerState<DataDeliveryScreen> createState() => _DataDeliveryScreenState();
}

class _DataDeliveryScreenState extends ConsumerState<DataDeliveryScreen> {
  final TextEditingController nameDelivery = TextEditingController();
  final TextEditingController dateDelivery = TextEditingController();
  DateTime? dateSelected;

  @override
  void dispose() {
    nameDelivery.dispose();
    dateDelivery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<LoginState>(loginProvider, (previous, next) {
      if (next is LoginSuccess) {
        final coordinator = ref.watch(userApplicationProvider);

        if (coordinator != null) {
          log('Is active: ${coordinator.active}');

          bool isActive = coordinator.active;

          if (isActive) {
            cambiarPantallaConNuevaPila(context, MenuScreen());
          } else {
            cambiarPantallaConNuevaPila(context, WelcomeScreen());
          }
        }
      } else if (next is LoginFailure) {
        MySnackBar.error(context, next.error);
      }
    });

    final loginState = ref.watch(loginProvider);

    return backgroundScreen(
      SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(),
                title('Datos de la entrega'),
                Column(
                  children: [
                    TextFieldCustom(
                      label: "Nombre de la entrega",
                      controller: nameDelivery,
                      prefixIcon: Icons.person,
                      textInputType: TextInputType.emailAddress,
                      marginVertical: 8,
                    ),
                    SizedBox(height: 10),
                    DatePickerTextField(
                      label: "Fecha de la entrega",
                      controller: dateDelivery,
                      marginVertical: 8,
                      onDateSelected: (newDate) => dateSelected = newDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                      titleAlertDialog: 'Fecha de la entrega',
                    ),
                  ],
                ),

                BotonAncho(
                  text: "Siguiente",
                  onPressed: _nextStep,
                  marginVertical: 0,
                  marginHorizontal: 0,
                  backgroundColor: secondary,
                  textColor: white,
                  paddingHorizontal: 80,
                ),
              ],
            ),
            if (loginState is LoginLoading) const LoadingIndicator(),
          ],
        ),
      ),
    );
  }

  void _nextStep() {
    if (nameDelivery.text.isEmpty) {
      MySnackBar.error(context, 'Por favor ingrese el nombre de la entrega');
      return;
    }
    if (dateSelected == null) {
      MySnackBar.error(context, 'Por favor seleccione la fecha de la entrega');
      return;
    }

    if (widget.deliveryType == TypesOfDeliveries.entregaDeCanastas) {
      cambiarPantalla(
        context,
        OrdersByDeliveryScreen(nameDelivery.text, dateSelected!),
      );
    } else {
      cambiarPantalla(context, AddBenefitsFinancialAidScreen(nameDelivery.text, dateSelected!));
    }
    // FocusScope.of(context).unfocus();
    // ref
    //     .read(loginProvider.notifier)
    //     .loginUser(username: nameDelivery.text, password: dateDelivery.text);
  }
}
