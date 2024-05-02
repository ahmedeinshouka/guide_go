import 'package:flutter/material.dart';
import 'package:guidego_1/Screens/Login.dart';
import 'package:guidego_1/Screens/SignUp.dart';
import 'package:guidego_1/utils/theme/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.jpeg",
              fit: BoxFit.contain, // Ensure the image covers the entire screen
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SizedBox(), // Spacer to push content to the top
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your ultimate \nguide.',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 35,
                          fontFamily: "LilitaOne",
                        ),
                      ),
                      const SizedBox(height: 16),
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: "LilitaOne",
                          ),
                        ),
                        color: AppColors.primaryColor, // Use the same color as sign-up button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: const BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center( // Align the Row containing "New to the app?" in the center
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'New to the app? ',
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.primaryColor,
                                fontFamily: "LilitaOne",
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignupScreen()),
                                );
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: AppColors.primaryColor,
                                  decoration: TextDecoration.underline,
                                  fontFamily: "LilitaOne",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
