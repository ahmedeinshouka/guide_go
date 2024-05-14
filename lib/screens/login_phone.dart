import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guide_go/screens/SignUp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseApp app = Firebase.app();
  FirebaseAppCheck firebaseAppCheck = FirebaseAppCheck.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GUIDE GO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Loginphone(), // Your initial screen
    );
  }
}

class Loginphone extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    TextEditingController phoneNumberController = TextEditingController();
    String smsCode = ''; // Declare and initialize smsCode variable

    // Default country code for mobile numbers (Egypt: +20)
    String defaultCountryCode = '+20';

    Future<void> signInWithPhoneNumber(String phoneNumber) async {
      try {
        // Check if user with provided phone number already exists
        final QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .where('phoneNumber', isEqualTo: phoneNumber)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // User with provided phone number exists, sign in
          await _auth.signInWithPhoneNumber(phoneNumber);
          Navigator.pushReplacementNamed(context, '/'); // Navigate after login
          return;
        }

        // User with provided phone number does not exist, send verification code
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            UserCredential userCredential =
                await _auth.signInWithCredential(credential);
            Navigator.pushReplacementNamed(context, '/'); // Navigate after login
          },
          verificationFailed: (FirebaseAuthException e) {
            print("Verification Failed: $e");
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Verification Failed"),
                  content: Text("Failed to verify phone number."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("OK"),
                    ),
                  ],
                );
              },
            );
          },
          codeSent: (String verificationId, int? resendToken) async {
            smsCode = await showDialog( // Use smsCode here
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Enter SMS Code"),
                  content: TextField(),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, null),
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, smsCode),
                      child: Text("Submit"),
                    ),
                  ],
                );
              },
            );

            PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: verificationId, smsCode: smsCode);
            UserCredential userCredential =
                await _auth.signInWithCredential(credential);
            Navigator.pushReplacementNamed(context, '/'); // Navigate after login
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } catch (e) {
        print("Error during phone authentication: $e");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(
                  "An error occurred during phone authentication. Please try again."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Log in'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Log in',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50.0,
                    fontFamily: "LilitaOne",
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50),
                Row(
                  children: [
                    Text(defaultCountryCode), // Display default country code
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(48),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String phoneNumber = phoneNumberController.text.trim();
                    if (phoneNumber.isNotEmpty) {
                      // Format phone number with default country code
                      phoneNumber = '$defaultCountryCode$phoneNumber';
                      await signInWithPhoneNumber(phoneNumber);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Error"),
                            content:
                                Text("Please enter a phone number."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xff003961)),
                  ),
                  child: SizedBox(
                    child: Text(
                      'Login with Phone Number',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                    width: 250,
                    height: 45,
                  ),
                ),
                SizedBox(height: 10),
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
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationThickness: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
