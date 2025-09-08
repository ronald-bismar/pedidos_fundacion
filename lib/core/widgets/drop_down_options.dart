import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/widgets/snackbar.dart';

class DropDownOptions extends StatefulWidget {
  final ValueChanged<String> onSelect;
  final List<String> items;
  final String itemInitial;
  final IconData? icon;
  final String? messageInfo;
  final String? messageNotShow;

  const DropDownOptions({
    super.key,
    required this.onSelect,
    required this.items,
    this.itemInitial = '',
    this.icon,
    this.messageInfo,
    this.messageNotShow,
  });

  @override
  DropDownOptionsState createState() => DropDownOptionsState();
}

class DropDownOptionsState extends State<DropDownOptions>
    with SingleTickerProviderStateMixin {
  late String selectedValue;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool? showDropDown = true;

  bool _isExpanded = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _buttonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    selectedValue = widget.itemInitial;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _toggleDropdown() {
    if (_isExpanded) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    setState(() => _isExpanded = true);
    _controller.forward();

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    setState(() => _isExpanded = false);
    _controller.reverse().then((_) => _removeOverlay());
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 4),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    alignment: Alignment.topCenter,
                    scaleY: _animation.value,
                    child: Opacity(
                      opacity: _animation.value,
                      child: Container(
                        constraints: BoxConstraints(maxHeight: double.infinity),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 8),
                            ...widget.items.map(_buildListItem),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(String item) {
    final isSelected = item == selectedValue;

    return InkWell(
      onTap: () => _selectItem(item),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (widget.icon != null) ...[
              Icon(
                widget.icon,
                color: isSelected ? dark : Colors.grey.shade600,
                size: 20,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                item,
                style: TextStyle(
                  color: isSelected ? dark : Colors.black87,
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected) Icon(Icons.check, color: dark, size: 20),
          ],
        ),
      ),
    );
  }

  void enableDropDown(bool show) {
    showDropDown = show;
  }

  void _selectItem(String item) {
    setState(() => selectedValue = item);
    log('Seleccionaste: $item');
    widget.onSelect(item);
    _closeDropdown();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TapRegion(
        onTapOutside: (_) {
          if (_isExpanded) _closeDropdown();
        },
        child: GestureDetector(
          onTap: () {
            if (showDropDown == false) {
              MySnackBar.show(context, widget.messageNotShow ?? '');
              return;
            }
            _toggleDropdown();
          },
          child: Container(
            key: _buttonKey,
            height: 56,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_isExpanded ? 0.15 : 0.08),
                  blurRadius: _isExpanded ? 12 : 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: _isExpanded ? dark : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
