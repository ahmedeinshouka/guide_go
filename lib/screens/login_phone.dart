import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guide_go/screens/SignUp.dart';



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

    Future<void> createUserDocumentIfNotExists(User user) async {
      try {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'email': user.email ?? '', // Handle case where email might be null
            'fullName': user.displayName ?? '', // Handle case where displayName might be null
            'password': '',
            'city': '',
            'country': '',
            'dateOfBirth': '',
            'photoUrl': '',
            'region': '',
            'phoneNumber': user.phoneNumber ?? '',
            "userType": '',
          });
        }
      } catch (e) {
        print("Error creating user document: $e");
      }
    }

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
            await createUserDocumentIfNotExists(userCredential.user!);
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
            String? enteredSmsCode = await showDialog(
              context: context,
              builder: (BuildContext context) {
                String tempSmsCode = '';
                return AlertDialog(
                  title: Text("Enter SMS Code"),
                  content: TextField(
                    onChanged: (value) {
                      tempSmsCode = value;
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, null),
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, tempSmsCode),
                      child: Text("Submit"),
                    ),
                  ],
                );
              },
            );

            if (enteredSmsCode == null || enteredSmsCode.isEmpty) {
              // Handle cancellation case
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Verification Canceled"),
                    content: Text("Phone number verification was canceled."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("OK"),
                      ),
                    ],
                  );
                },
              );
              return;
            }

            smsCode = enteredSmsCode;

            PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: verificationId, smsCode: smsCode);
            UserCredential userCredential =
                await _auth.signInWithCredential(credential);
            await createUserDocumentIfNotExists(userCredential.user!);
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
                Row(mainAxisAlignment: MainAxisAlignment.center,
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
                  SvgPicture.asset("assets/mobile-phone-authentication-2.svg",fit: BoxFit.cover,height: 50,)  ],
                ),
                SizedBox(height: 200),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     // Display default country code
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(suffixIcon: Icon(Icons.phone),prefix:   Text(defaultCountryCode),
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(48),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 100),
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
                            content: Text("Please enter a phone number."),
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
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                    
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('or you need to ?',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w900),),
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
                        style: TextStyle(fontWeight: FontWeight.bold,
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
