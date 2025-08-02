import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';

class AutoCompleteTextField extends StatefulWidget {
  final String? label;
  final TextEditingController controller;
  final TextInputType textInputType;
  final TextCapitalization textCapitalization;
  final String? initialValue;
  final double marginHorizontal;
  final double marginVertical;
  final IconData? prefixIcon;
  final List<String> autocompleteOptions; // Lista personalizada de opciones

  const AutoCompleteTextField({
    super.key,
    this.label,
    required this.controller,
    this.textInputType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.initialValue,
    this.marginHorizontal = 20,
    this.marginVertical = 10,
    this.prefixIcon,
    required this.autocompleteOptions,
  });

  @override
  State<AutoCompleteTextField> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<AutoCompleteTextField> {
  late TextEditingController _internalController;
  bool _isListenerAdded = false;

  @override
  void initState() {
    super.initState();
    // Crear el controller interno una sola vez
    _internalController = TextEditingController(text: widget.controller.text);

    if (widget.initialValue != null) {
      widget.controller.text = widget.initialValue!;
      _internalController.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    _internalController.dispose();
    super.dispose();
  }

  void _setupControllerSync() {
    if (!_isListenerAdded) {
      _internalController.addListener(() {
        if (_internalController.text != widget.controller.text) {
          widget.controller.text = _internalController.text;
        }
      });

      // También sincronizar en la otra dirección si es necesario
      widget.controller.addListener(() {
        if (widget.controller.text != _internalController.text) {
          _internalController.text = widget.controller.text;
        }
      });

      _isListenerAdded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: widget.marginHorizontal,
        vertical: widget.marginVertical,
      ),
      child: _buildAutocompleteField(),
    );
  }

  Widget _buildAutocompleteField() {
    final options = widget.autocompleteOptions;

    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return options.where((String option) {
          return option.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          );
        });
      },
      onSelected: (String selection) {
        widget.controller.text = selection;
        _internalController.text =
            selection; // Sincronizar con el controller interno
      },
      fieldViewBuilder:
          (
            BuildContext context,
            TextEditingController fieldController, // Cambia este nombre
            FocusNode fieldFocusNode,
            VoidCallback onFieldSubmitted,
          ) {
            // Usar nuestro controller interno y sincronizar solo una vez
            fieldController.text = _internalController.text;
            _setupControllerSync();

            // Sincronizar el fieldController con nuestro controller interno
            fieldController.addListener(() {
              if (fieldController.text != _internalController.text) {
                _internalController.text = fieldController.text;
              }
            });

            return TextFormField(
              controller: fieldController,
              focusNode: fieldFocusNode,
              keyboardType: widget.textInputType,
              textCapitalization: widget.textCapitalization,
              decoration: InputDecoration(
                fillColor: white,
                filled: true,
                hintText: widget.label,
                prefixIcon: widget.prefixIcon != null
                    ? Icon(widget.prefixIcon)
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            );
          },
      optionsViewBuilder:
          (
            BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options,
          ) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  width:
                      MediaQuery.of(context).size.width -
                      (widget.marginHorizontal * 2),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      return ListTile(
                        dense: true,
                        title: Text(option),
                        onTap: () {
                          onSelected(option);
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
    );
  }
}
