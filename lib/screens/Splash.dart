import 'dart:async';
import 'package:flutter/material.dart';
import 'HomePageSc.dart'; // Import the HomePage widget

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Future.delayed to wait for a specified duration
    Future.delayed(Duration(seconds: 10), () {
      // Use Navigator to push the HomePage onto the navigation stack
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Intro()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/background.jpeg",
              fit: BoxFit.contain, // Ensure the image covers the entire screen
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20, // Adjust the bottom margin as needed
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'Loading...',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
