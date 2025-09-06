import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';

class DatePickerTextField extends StatefulWidget {
  final String? label;
  final TextEditingController controller;
  final double marginHorizontal;
  final double marginVertical;
  final bool enabled;
  final Function(DateTime?) onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String titleAlertDialog;

  const DatePickerTextField({
    super.key,
    this.label,
    required this.controller,
    this.marginHorizontal = 20,
    this.marginVertical = 10,
    this.enabled = true,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.titleAlertDialog = 'Seleccionar fecha',
  });

  @override
  State<DatePickerTextField> createState() => _DatePickerTextFieldState();
}

class _DatePickerTextFieldState extends State<DatePickerTextField> {
  DateTime? _selectedDate;

  void _updateController() {
    if (_selectedDate != null) {
      widget.controller.text = _formatDate(_selectedDate!);
    }
  }

  String _formatDate(DateTime date) {
    List<String> months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }

  DateTime get _firstDate {
    if (widget.firstDate != null) {
      return widget.firstDate!;
    }
    // Por defecto, 10 años atrás desde hoy
    return DateTime.now().subtract(const Duration(days: 365 * 100));
  }

  DateTime get _lastDate {
    if (widget.lastDate != null) {
      return widget.lastDate!;
    }
    // Por defecto, hoy
    return DateTime.now();
  }

  Future<void> _showHoloDatePicker(BuildContext context) async {
    if (!widget.enabled) return;

    final DateTime? datePicked = await DatePicker.showSimpleDatePicker(
      context,
      firstDate: _firstDate,
      lastDate: _lastDate,
      dateFormat: "dd-MMM-yyyy",
      looping: false,
      locale: DateTimePickerLocale.es,
      textColor: Colors.black87,
      titleText: widget.titleAlertDialog,
      confirmText: 'Confirmar',
      cancelText: 'Cancelar',
      itemTextStyle: TextStyle(fontSize: 20),
    );

    if (datePicked != null && datePicked != _selectedDate) {
      setState(() {
        _selectedDate = datePicked;
        widget.onDateSelected(_selectedDate);
        _updateController();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: widget.marginHorizontal,
        vertical: widget.marginVertical,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Campo principal
          TextFormField(
            controller: widget.controller,
            readOnly: true,
            enabled: widget.enabled,
            onTap: () =>
                _showHoloDatePicker(context), // Usar modal personalizable
            decoration: InputDecoration(
              fillColor: widget.enabled ? white : Colors.grey[100],
              filled: true,
              hintText: widget.label ?? 'Seleccionar fecha',
              hintStyle: const TextStyle(fontSize: 16),
              prefixIcon: Icon(Icons.event, color: dark, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            style: TextStyle(
              fontSize: 16,
              color: widget.enabled ? Colors.black87 : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
