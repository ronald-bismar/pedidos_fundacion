import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/alert_dialog_options.dart';
import 'package:pedidos_fundacion/core/widgets/autocomplete_textfield.dart';
import 'package:pedidos_fundacion/core/widgets/background.dart';
import 'package:pedidos_fundacion/core/widgets/boton_ancho.dart';
import 'package:pedidos_fundacion/core/widgets/logo.dart';
import 'package:pedidos_fundacion/core/widgets/snackbar.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';
import 'package:pedidos_fundacion/domain/entities/programa.dart';
import 'package:pedidos_fundacion/features/encargados/presentation/providers/update_location_provider.dart';
import 'package:pedidos_fundacion/features/encargados/presentation/screens/image_profile_screen.dart';
import 'package:pedidos_fundacion/features/beneficiarios/presentation/providers/grupos_provider.dart';
import 'package:pedidos_fundacion/toDataDynamic/cargos.dart';
import 'package:pedidos_fundacion/toDataDynamic/places.dart';

class LocationPostScreen extends ConsumerStatefulWidget {
  final Coordinator coordinator;
  const LocationPostScreen({super.key, required this.coordinator});

  @override
  ConsumerState<LocationPostScreen> createState() => _LocationPostScreenState();
}

class _LocationPostScreenState extends ConsumerState<LocationPostScreen> {
  String locationValue = '';
  Group? assignedGroup;

  @override
  Widget build(BuildContext context) {
    final updateLocation = ref.watch(updateLocationCoordinatorProvider);
    final isTutor = widget.coordinator.role == Role.tutor;

    final groupsAsync = ref.watch(groupsProvider);

    List<Group> groups = groupsAsync.maybeWhen(
      data: (data) => data,
      orElse: () => [],
    );

    return backgroundScreen(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Logo(),
            title('COMPLETE EL REGISTRO'),
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  AutoCompleteTextField(
                    label: "Lugar",
                    autocompleteOptions: places,
                    prefixIcon: Icons.location_on,
                    textInputType: TextInputType.name,
                    marginVertical: 8,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (value) => setState(() => locationValue = value),
                  ),

                  if (isTutor) ...[
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      child: AlertDialogOptions(
                        titleAlertDialog: 'Programa/Grupo',
                        widthAlertDialog: double.infinity,
                        itemInitial: '',
                        onSelect: (newGroup) => {
                          assignNewGroup(newGroup, groups),
                        },
                        items: groups.map((group) => group.groupName).toList(),
                        icon: Icons.group,
                        messageInfo: 'Programa/Grupo',
                      ),
                    ),
                  ],
                ],
              ),
            ),

            BotonAncho(
              text: "Registrar",
              onPressed: () async {
                if (locationValue.isEmpty) {
                  MySnackBar.info(context, 'Please enter a location');
                  return;
                }

                if (isTutor && assignedGroup == null) {
                  MySnackBar.info(context, 'Please enter an assigned group');
                  return;
                }

                final coordinatorWithLocation = widget.coordinator.copyWith(
                  location: locationValue.trim(),
                );

                updateLocation(coordinatorWithLocation, assignedGroup);

                cambiarPantallaConNuevaPila(
                  context,
                  ImageProfileScreen(coordinator: coordinatorWithLocation),
                );
              },
              marginVertical: 0,
              backgroundColor: white,
              textColor: dark,
              paddingHorizontal: 60,
            ),
          ],
        ),
      ),
    );
  }

  void assignNewGroup(String newGroup, List<Group> groups) {
    final groupObject = groups.firstWhere((g) => g.groupName == newGroup);
    assignedGroup = groupObject;
    setState(() {});
  }
}
