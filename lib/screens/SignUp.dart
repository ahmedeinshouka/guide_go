import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guide_go/screens/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController fullNameController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();
    // Sign user in
    Future<UserCredential> signInWithEmailandPassword(
  String email, String password, String fullName) async {
  try {
    // Sign in
    UserCredential userCredential =
        await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Add a new document for the user in the users collection if it does not already exist
    _firestore.collection('users').doc(userCredential.user?.uid).set({
      'uid': userCredential.user?.uid,
      'email': email,
      'fullName': fullName, // استخدم fullName الممرر كمعلمة
    }, SetOptions(merge: true));

    return userCredential;
  } on FirebaseAuthException catch (e) {
    throw Exception(e.code);
  }
}

// Create a new user
Future<UserCredential> signUpWithEmailandPassword(
    String email, String password, String fullName) async {
  try {
    UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // After creating a user, create a new document for the user in the users collection
    _firestore.collection('users').doc(userCredential.user?.uid).set({
      'uid': userCredential.user?.uid,
      'email': email,
      'fullName': fullName, // استخدم fullName الممرر كمعلمة
      // Add more fields as needed
    });

    return userCredential;
  } on FirebaseAuthException catch (e) {
    throw Exception(e.code);
  }
}


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Sign up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                'Sign up',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.08,
                  fontFamily: "LilitaOne",
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              'Welcome! Please enter your Name, email, and password to create your account.',
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
            ),
             SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            TextField(
              controller: fullNameController, // Full name text field
              decoration: InputDecoration(
                labelText: 'Full Name', // Label for full name field
                border: OutlineInputBorder(), // to make the text field box-shaped
              ),
            ),
            SizedBox(height: 10), // add spacing between fields
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(), // to make the text field box-shaped
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(), // to make the text field box-shaped
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: confirmPasswordController, // Confirm password field
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password', // Label for confirm password field
                border: OutlineInputBorder(), // to make the text field box-shaped
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Check if passwords match before signing up
                    if (passwordController.text == confirmPasswordController.text) {
                      try {
                        await signUpWithEmailandPassword(
                            emailController.text, passwordController.text, fullNameController.text);
                        // Sign up successful, handle navigation to next page after sign up
                      } catch (e) {
                        // Error occurred during sign up, handle displaying error message to user
                        print('Error during sign up: $e');
                      }
                    } else {
                      // Passwords do not match, display error message
                      print('Passwords do not match');
                    }
                  },
                  child: Text('Sign Up'),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationThickness: 1,
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

