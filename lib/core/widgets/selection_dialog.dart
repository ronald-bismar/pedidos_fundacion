import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';

class SelectionDialog {
  static Future<String?> show({
    required BuildContext context,
    required List<String> items,
    required Function(String) onSelect,
    IconData? icon,
    String? titleAlertDialog,
    String? selectedValue,
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => _SelectionDialogWidget(
        items: items,
        onSelect: onSelect,
        icon: icon,
        titleAlertDialog: titleAlertDialog,
        selectedValue: selectedValue,
      ),
    );
  }
}

class _SelectionDialogWidget extends StatefulWidget {
  final List<String> items;
  final Function(String) onSelect;
  final IconData? icon;
  final String? titleAlertDialog;
  final String? selectedValue;

  const _SelectionDialogWidget({
    required this.items,
    required this.onSelect,
    this.icon,
    this.titleAlertDialog,
    this.selectedValue,
  });

  @override
  State<_SelectionDialogWidget> createState() => _SelectionDialogWidgetState();
}

class _SelectionDialogWidgetState extends State<_SelectionDialogWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    // Iniciar la animación automáticamente
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
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
              final item = widget.items[index];
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
                  title: Text(item),
                  trailing: widget.selectedValue == item
                      ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                      : null,
                  onTap: () {
                    Navigator.of(context).pop(item);
                    widget.onSelect(item);
                  },
                ),
              );
            },
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
