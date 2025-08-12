import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';

class AutoCompleteTextField extends StatefulWidget {
  final String? label;
  final TextInputType textInputType;
  final TextCapitalization textCapitalization;
  final String? initialValue;
  final double marginHorizontal;
  final double marginVertical;
  final IconData? prefixIcon;
  final List<String> autocompleteOptions;
  final ValueChanged<String> onChanged;

  const AutoCompleteTextField({
    super.key,
    this.label,
    this.textInputType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.initialValue,
    this.marginHorizontal = 20,
    this.marginVertical = 10,
    this.prefixIcon,
    required this.autocompleteOptions,
    required this.onChanged,
  });

  @override
  State<AutoCompleteTextField> createState() => _AutoCompleteTextFieldState();
}

class _AutoCompleteTextFieldState extends State<AutoCompleteTextField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: widget.marginHorizontal,
        vertical: widget.marginVertical,
      ),
      child: Autocomplete<String>(
        initialValue: TextEditingValue(text: widget.initialValue ?? ''),
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty();
          }
          return widget.autocompleteOptions.where((String option) {
            return option.toLowerCase().contains(
              textEditingValue.text.toLowerCase(),
            );
          });
        },
        onSelected: (String selection) {
          setState(() {
            widget.onChanged(selection);
          });
        },
        fieldViewBuilder:
            (
              BuildContext context,
              TextEditingController fieldController,
              FocusNode fieldFocusNode,
              VoidCallback onFieldSubmitted,
            ) {
              return TextFormField(
                controller: fieldController,
                focusNode: fieldFocusNode,
                keyboardType: widget.textInputType,
                textCapitalization: widget.textCapitalization,
                onChanged: (value) {
                  setState(() {
                    widget.onChanged(value);
                  });
                },
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
      ),
    );
  }
}
