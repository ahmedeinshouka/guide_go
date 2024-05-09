import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1st_screen/Signup.dart';

class LoginScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Log in'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Log in',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50.0, fontFamily: "LilitaOne"),
              textAlign: TextAlign.center,
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      // ignore: unused_local_variable
                      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      // Login successful
                      // After successful login, navigate to the chat list page
                      Navigator.pushReplacementNamed(context, '/chatList');
                    } catch (e) {
                      // An error occurred
                      print('Error during login: $e');
                    }
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    //حد يبقي يضيف هنا سطر لتكبير و تصغير حجم الزرار
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      TextStyle(color: Colors.white, fontSize: 20), // تغيير لون النص إلى أبيض
                    ),
                  ),
                  child: Text('Login'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('New to the app?'),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  child: const Text(
                    'Signup',
                    style: TextStyle(decoration: TextDecoration.underline, decorationThickness: 1),
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






