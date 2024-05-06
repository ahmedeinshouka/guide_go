// ignore_for_file: unused_import, unused_field
import 'package:email_validator_flutter/email_validator_flutter.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart'; // Import csc_picker for country/region
import 'package:intl/intl.dart';
import'package:guide_go/widgets/date_of_birth_field.dart';
import 'package:guide_go/widgets/country_region_picker.dart'; // Replace with your actual path

class Edit_profile extends StatefulWidget {
  const Edit_profile({super.key});

  @override
  State<Edit_profile> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Edit_profile> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  String _dateOfBirth = ''; // Set an initial value to avoid potential errors
  String _country =
      ''; // Use separate variables for country and region (optional)
  String _region =
      ''; // Use separate variables for country and region (optional)
  String _city = ''; // Use separate variables for country and region (optional)
  final TextEditingController _dateController = TextEditingController();
  bool _validateEmail(String email) {
  RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  return emailRegex.hasMatch(email);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            // Text widget for page title
            Text(
              'Edit Profile',
              style: TextStyle(fontSize: 30.0, color: Colors.black), // Customize style as needed
            ),
            const SizedBox(height: 0.0), // Add spacing between title and content (optional)

            // Stack positions text and image
            Stack(
              children: [
                // Centered and sized profile picture
                Center(
                  child: ClipOval(
                    child: Image.asset(
                      'assets/DSC_0564 copy.jpg', // Replace with your actual path
                      width: 120.0, // Set a larger width for a bigger image
                      height: 120.0, // Set a larger height for a bigger image
                      fit: BoxFit.cover, // Adjust fit to cover the entire area
                    ),
                  ),
                ),
              ]
            ),
            const SizedBox(height: 0.0),

            // TextFields with padding
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextFormField(
                initialValue: _name,
                decoration: InputDecoration(
                  labelText: 'Name',
                  contentPadding:
                      const EdgeInsets.all(12.0), // Adjust padding as needed
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(0.0), // Creates a square
                    borderSide: const BorderSide(
                        color: Colors.grey), // Customize border color
                  ),
                ),
                onSaved: (value) => setState(() => _name = value!),
              ),
            ),
            Padding(
  padding: const EdgeInsets.symmetric(vertical: 10.0),
  child: TextFormField(
    initialValue: _email,
    decoration: InputDecoration(
      labelText: 'Email',
      contentPadding: const EdgeInsets.all(12.0), // Adjust padding as needed
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0.0), // Creates a square
        borderSide: const BorderSide(color: Colors.grey), // Customize border color
      ),
    ),
    validator: (value) {
      if (value!.trim().isEmpty) {
        return 'Please enter your email address';
      } else if (!_validateEmail(value.trim())) {
        return 'Please enter a valid email address';
      }
      return null; // Return null when validation is successful
    },
    onSaved: (value) => setState(() => _email = value!),
  ),
),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextFormField(
                initialValue: _password,
                obscureText: true, // Hides the entered password characters
                decoration: InputDecoration(
                  labelText: 'Password',
                  contentPadding:
                      const EdgeInsets.all(12.0), // Adjust padding as needed
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(0.0), // Creates a square
                    borderSide: const BorderSide(
                        color: Colors.grey), // Customize border color
                  ),
                ),
                onSaved: (value) => setState(() => _password = value!),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: DateOfBirthField(
                onDateSelected: (selectedDate) {
                  if (selectedDate != null) {
                    setState(() {
                      _dateOfBirth =
                          selectedDate.toString(); // Update your state variable
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: CountryRegionPicker(
                onSelected: (country, state, city) {
                  setState(() {
                    _country = country;
                    _region = state;
                    _city =
                        city; // Add a variable to store city selection (optional)
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _formKey.currentState!.save();
                // Add logic to save changes, including country, region, and date of birth
                print(
                    'Name: $_name, Email: $_email, Password: $_password, Date of Birth: $_dateOfBirth, Country: $_country, Region: $_region');
              },
              child: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
