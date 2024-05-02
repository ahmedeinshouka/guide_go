import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paddingValue = screenWidth * 0.05;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildInputForm('Full Name', false, paddingValue, (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your full name';
            } else if (!isNameValid(value)) {
              return 'Name should not contain numbers';
            }
            return null;
          }),
          buildInputForm('Email Address', true, paddingValue, (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email address';
            } else if (!isValidEmail(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          }),
          buildInputForm('Your Password', false, paddingValue, (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          }),
          buildInputForm('Re-enter Your Password', true, paddingValue, (value) {
            if (value == null || value.isEmpty) {
              return 'Please re-enter your password';
            }
            return null;
          }),
          SizedBox(height: 20), // Add spacing between form fields and the login button
          GestureDetector(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                // Perform login logic here
              }
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.black, // Customize the button color as needed
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Sign up ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildInputForm(
      String label,
      bool pass,
      double paddingValue,
      String? Function(String?)? validator,
      ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: paddingValue),
      child: TextFormField(
        obscureText: pass,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.black87,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isNameValid(String name) {
    // Regular expression to check if name contains only letters and spaces
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(name);
  }
}
