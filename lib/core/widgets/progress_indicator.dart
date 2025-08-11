import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';

class LoadingIndicator extends StatelessWidget {
  final bool showBackgroundDark;
  const LoadingIndicator({this.showBackgroundDark = true, super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: showBackgroundDark
            ? Colors.black.withOpacity(0.5)
            : Colors.transparent,
        child: const Center(
          child: CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation<Color>(white),
          ),
        ),
      ),
    );
  }
}
