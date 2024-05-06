import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';

class CountryRegionPicker extends StatefulWidget {
  final Function(String country, String state, String city) onSelected;

  const CountryRegionPicker({super.key, required this.onSelected});

  @override
  State<CountryRegionPicker> createState() => _CountryRegionPickerState();
}

class _CountryRegionPickerState extends State<CountryRegionPicker> {
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";

  @override
  Widget build(BuildContext context) {
    return CSCPicker(
      layout: Layout.vertical,
      //flagState: CountryFlag.DISABLE, // Optional: disable country flags
      onCountryChanged: (country) {
        setState(() {
          countryValue = "";
          stateValue = ""; // Reset state when country changes
          cityValue = ""; // Reset city when country changes (optional)
        });
        widget.onSelected(countryValue, stateValue, cityValue);
      },
      onStateChanged: (state) {
        setState(() {
          stateValue = "";
          cityValue = ""; // Reset city when state changes (optional)
        });
        widget.onSelected(countryValue, stateValue, cityValue);
      },
      onCityChanged: (city) {
        setState(() {
          cityValue = "";
        });
        widget.onSelected(countryValue, stateValue, cityValue);
      },
    );
  }
}

