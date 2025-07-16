import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double widthLogo;
  final double heightLogo;
  const Logo({super.key, this.widthLogo = 200, this.heightLogo = 100});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo.png',
      width: widthLogo,
      height: heightLogo,
      fit: BoxFit.contain,
    );
  }
}
