// ignore_for_file: unused_import, unused_field, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart'; // Import csc_picker for country/region
import 'package:intl/intl.dart';
class DateOfBirthField extends StatefulWidget {
  final Function(DateTime? date) onDateSelected;

  const DateOfBirthField({required this.onDateSelected, super.key});

  @override
  _DateOfBirthFieldState createState() => _DateOfBirthFieldState();
}

class _DateOfBirthFieldState extends State<DateOfBirthField> {
  final _dateController = TextEditingController(text: '');
  DateTime? _selectedDate;

  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd-MM-yyyy').format(picked); // Customized date format
      });
      widget.onDateSelected(picked); // Call parent callback function with selected date
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: _dateController,
      decoration: const InputDecoration(
        labelText: 'DATE',
        prefixIcon: Icon(Icons.calendar_today),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      onTap: () => _selectDate(context),
    );
  }
}
