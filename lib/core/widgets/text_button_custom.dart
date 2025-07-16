import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';

class TextButtonCustom extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double marginHorizontal;
  final double marginVertical;
  final double fontSize;
  final Color textColor;
  final double paddingHorizontal;
  const TextButtonCustom({
    super.key,
    required this.text,
    required this.onPressed,
    this.marginHorizontal = 60,
    this.marginVertical = 20,
    this.fontSize = 18,
    this.textColor = secondary,
    this.paddingHorizontal = 12,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = TextButton.styleFrom(
      padding: EdgeInsets.symmetric(
        horizontal: paddingHorizontal,
        vertical: 12,
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: marginHorizontal,
        vertical: marginVertical,
      ),
      child: SizedBox(
        child: TextButton(
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
