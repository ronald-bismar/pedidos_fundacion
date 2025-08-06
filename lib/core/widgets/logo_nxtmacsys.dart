import 'package:flutter/material.dart';

class LogoNextMacroSystem extends StatelessWidget {
  final double widthLogo;
  final double heightLogo;
  const LogoNextMacroSystem({super.key, this.widthLogo = 200, this.heightLogo = 100});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo_nxtmacsys.webp',
      width: widthLogo,
      height: heightLogo,
      fit: BoxFit.contain,
    );
  }
}
