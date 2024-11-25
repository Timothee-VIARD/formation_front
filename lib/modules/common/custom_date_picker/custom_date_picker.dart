import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCalendarDatePicker extends StatefulWidget {
  final TextEditingController controller;

  const CustomCalendarDatePicker({
    super.key,
    required this.controller,
  });

  @override
  CustomCalendarDatePickerState createState() =>
      CustomCalendarDatePickerState();
}

class CustomCalendarDatePickerState extends State<CustomCalendarDatePicker> {
  late OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    if (widget.controller.text.isEmpty) {
      widget.controller.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
    }
  }

  void _showCalendarOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry);
  }

  void _hideCalendarOverlay() {
    if (_overlayEntry.mounted) {
      _overlayEntry.remove();
    }
  }

  void _updateDate(DateTime newDate) {
    if (_selectedDate.month == newDate.month &&
        _selectedDate.day == newDate.day) {
      return;
    }
    setState(() {
      _selectedDate = newDate;
      widget.controller.text = DateFormat('dd/MM/yyyy').format(newDate);
    });

    _hideCalendarOverlay();
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _hideCalendarOverlay,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            width: 300,
            child: CompositedTransformFollower(
              link: _layerLink,
              offset: const Offset(0, 50),
              showWhenUnlinked: false,
              child: Material(
                color: Colors.white,
                elevation: 4.0,
                child: Theme(
                  data: ThemeData(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xFF494949),
                      onSurface: Colors.black,
                    ),
                  ),
                  child: Localizations.override(
                    context: context,
                    locale: const Locale('fr', 'FR'),
                    child: CalendarDatePicker(
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      onDateChanged: _updateDate,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: widget.controller,
        readOnly: true,
        decoration: const InputDecoration(
          labelText: 'Date sélectionnée',
          suffixIcon: Icon(Icons.calendar_today),
        ),
        onTap: _showCalendarOverlay,
      ),
    );
  }
}
