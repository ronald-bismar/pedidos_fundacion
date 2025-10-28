import 'package:flutter/material.dart';

class BotonNormal extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color buttonColor;
  final Color textColor;
  const BotonNormal({
    super.key,
    required this.onPressed,
    required this.label,
    required this.buttonColor,
    this.textColor = Colors.white,
  });
  @override
  Widget build(BuildContext context) {
    return botonNormal(
      onPressed: onPressed,
      label: label,
      buttonColor: buttonColor,
      textColor: textColor,
    );
  }
}

Widget botonNormal({
  required VoidCallback onPressed,
  required String label,
  required Color buttonColor,
  required Color textColor,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ButtonStyle(
      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      backgroundColor: WidgetStateProperty.all<Color>(buttonColor),
    ),
    child: Text(label, style: TextStyle(fontSize: 14, color: textColor)),
  );
}
