import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isObscure = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildInputForm(
            'Email Address',
            false,
            _emailController,
                (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email address';
              } else if (!isValidEmail(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          buildInputForm(
            'Your Password',
            true,
            _passwordController,
                (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                // Perform login logic here
                print(_emailController.text);
              }
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.black, // Changed the button color to black
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Log in',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "LilitaOne",
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
      bool obscureText,
      TextEditingController controller,
      String? Function(String?)? validator,
      ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText ? _isObscure : false,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black87),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          suffixIcon: obscureText
              ? IconButton(
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
            icon: Icon(
              _isObscure ? Icons.visibility : Icons.visibility_off,
            ),
          )
              : null,
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
