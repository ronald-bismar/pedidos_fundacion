import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';

class BotonAncho extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double marginHorizontal;
  final double marginVertical;
  final double fontSize;
  final Color backgroundColor;
  final Color textColor;
  final double paddingHorizontal;
  const BotonAncho({
    super.key,
    required this.text,
    required this.onPressed,
    this.marginHorizontal = 60,
    this.marginVertical = 20,
    this.fontSize = 18,
    this.backgroundColor = secondary,
    this.textColor = white,
    this.paddingHorizontal = 12,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
      padding: MaterialStateProperty.all(
        EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: 12),
      ),
      backgroundColor: MaterialStateProperty.all(backgroundColor),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: marginHorizontal,
        vertical: marginVertical,
      ),
      child: SizedBox(
        child: ElevatedButton(
          style: buttonStyle,
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
