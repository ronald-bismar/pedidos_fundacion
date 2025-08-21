import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/widgets/selection_dialog.dart';

class AlertDialogOptions extends StatefulWidget {
  final ValueChanged<String> onSelect;
  final List<String> items;
  final String itemInitial;
  final double? widthAlertDialog;
  final double? heightAlertDialog;
  final String? titleAlertDialog;
  final IconData? icon;
  final String? messageInfo;
  final Color? backgroundColor;
  final TextAlign textAlignment;
  final double? textSize;

  const AlertDialogOptions({
    super.key,
    required this.onSelect,
    required this.items,
    this.itemInitial = '',
    this.widthAlertDialog,
    this.heightAlertDialog,
    this.titleAlertDialog,
    this.icon,
    this.messageInfo,
    this.backgroundColor,
    this.textAlignment = TextAlign.start,
    this.textSize,
  });

  @override
  AlertDialogOptionsState createState() => AlertDialogOptionsState();
}

class AlertDialogOptionsState extends State<AlertDialogOptions>
    with SingleTickerProviderStateMixin {
  late String selectedValue;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.itemInitial;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.widthAlertDialog,
        height: widget.heightAlertDialog ?? 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.backgroundColor ?? Colors.white,
            foregroundColor: Colors.black87,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          onPressed: () => _showSelectionDialog(context),
          child: Row(
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: dark, size: 24),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  selectedValue.isEmpty
                      ? widget.messageInfo ?? 'Seleccionar'
                      : selectedValue,
                  textAlign: widget.textAlignment,
                  style: TextStyle(
                    color: selectedValue.isEmpty
                        ? Colors.grey.shade600
                        : Colors.black87,
                    fontSize: widget.textSize ?? 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _controller.value * 3.14159,
                    child: Icon(Icons.arrow_drop_down, color: dark),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Muestra el diálogo de selección usando el widget separado
  void _showSelectionDialog(BuildContext context) {
    _controller.forward(from: 0.0);

    SelectionDialog.show(
      context: context,
      items: widget.items,
      icon: widget.icon,
      titleAlertDialog: widget.titleAlertDialog,
      selectedValue: selectedValue,
      onSelect: (String value) {
        setState(() => selectedValue = value);
        log('Seleccionaste: $value');
        widget.onSelect(value);
      },
    ).then((value) {
      // Solo animar la flecha de vuelta
      _controller.reverse();
    });
  }
}
