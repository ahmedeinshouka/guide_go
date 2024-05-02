import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;

  const PrimaryButton({required this.buttonText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Call the onPressed callback when the button is tapped
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(200),
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.08,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(200),
            color: Colors.black,
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.white, // Set text color to white
            ),
          ),
        ),
      ),
    );
  }
}
