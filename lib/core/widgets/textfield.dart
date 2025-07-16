import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';

class TextFieldCustom extends StatefulWidget {
  final String? label;
  final TextEditingController controller;
  final TextInputType textInputType;
  final TextCapitalization textCapitalization;
  final String? initialValue;
  final bool obscureText;
  final double marginHorizontal;
  final double marginVertical;
  final IconData? prefixIcon; // Nuevo atributo para el ícono de prefijo
  final bool readOnly;

  const TextFieldCustom({
    super.key,
    this.label,
    required this.controller,
    this.textInputType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.initialValue,
    this.obscureText = false,
    this.marginHorizontal = 20,
    this.marginVertical = 10,
    this.prefixIcon,
    this.readOnly = false, // Constructor actualizado
  });

  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    // Set the initial value of the controller if initialValue is provided
    if (widget.initialValue != null) {
      widget.controller.text = widget.initialValue!;
    }
  }

  void toggleVisibility() {
    setState(() => _obscureText = !_obscureText);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: widget.marginHorizontal,
        vertical: widget.marginVertical,
      ),
      child: TextFormField(
        keyboardType: widget.textInputType,
        controller: widget.controller,
        obscureText: _obscureText,
        textCapitalization: widget.textCapitalization,
        decoration: InputDecoration(
          fillColor: white,
          filled: true,
          hintText: widget.label,
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon) // Ícono de prefijo
              : null,
          suffixIcon: widget.obscureText
              ? IconButton(
                  onPressed: toggleVisibility,
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                )
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
        readOnly: widget.readOnly,
      ),
    );
  }
}
