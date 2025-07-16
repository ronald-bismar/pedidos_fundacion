import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';

class AlertDialogOptions extends StatefulWidget {
  final ValueChanged<String> onSelect;
  final List<String> items;
  final String itemInitial;
  final double? widthAlertDialog;
  final double? heightAlertDialog;
  final String? titleAlertDialog;
  final IconData? icon;
  final String? messageInfo;

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
  });

  @override
  AlertDialogOptionsState createState() => AlertDialogOptionsState();
}

class AlertDialogOptionsState extends State<AlertDialogOptions>
    with SingleTickerProviderStateMixin {
  late String selectedValue;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.itemInitial;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
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
            backgroundColor: Colors.white,
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
                  style: TextStyle(
                    color: selectedValue.isEmpty
                        ? Colors.grey.shade600
                        : Colors.black87,
                    fontSize: 16,
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

  void _showSelectionDialog(BuildContext context) {
    _controller.forward(from: 0.0);
    showDialog<String>(
      context: context,
      builder: (context) => ScaleTransition(
        scale: _scaleAnimation,
        child: AlertDialog(
          title: Row(
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: secondary),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  widget.titleAlertDialog ?? 'Selecciona una opción',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final zona = widget.items[index];
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 200 + (index * 50)),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 50 * (1 - value)),
                      child: Opacity(opacity: value, child: child),
                    );
                  },
                  child: ListTile(
                    title: Text(zona),
                    trailing: selectedValue == zona
                        ? Icon(
                            Icons.check,
                            color: Theme.of(context).primaryColor,
                          )
                        : null,
                    onTap: () => Navigator.of(context).pop(zona),
                  ),
                );
              },
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    ).then((value) {
      if (value != null) {
        setState(() => selectedValue = value);
        log('Seleccionaste: $value');
        widget.onSelect(value);
      }
      _controller.reverse();
    });
  }
}
