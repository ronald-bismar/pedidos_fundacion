import 'package:flutter/material.dart';

class TextNextMacroSystem extends StatelessWidget {
  final double widthText;
  final double heightText;
  const TextNextMacroSystem({
    super.key,
    this.widthText = 200,
    this.heightText = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/text_nxtmacsys.webp',
      width: widthText,
      height: heightText,
      fit: BoxFit.contain,
    );
  }
}
