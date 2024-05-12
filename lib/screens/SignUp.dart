import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guide_go/screens/Login.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController fullNameController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    fullNameController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
    String city,
    String country,
    String dateOfBirth,
    String facebookLink,
    String imageUrl,
    String instagramLink,
    String region,
    String whatsappLink,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'uid': userCredential.user?.uid,
        'email': email,
        'fullName': name,
        'password': password,
        'city': city,
        'country': country,
        'dateOfBirth': dateOfBirth,
        'facebookLink': facebookLink,
        'imageUrl': imageUrl,
        'instagramLink': instagramLink,
        'region': region,
        'whatsappLink': whatsappLink
      });
      // Sign up successful, handle navigation to next page after sign up
      // Navigator.pushReplacementNamed(context, '/next_page');
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Check again your sign up info 🥹😁';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sign Up Error"),
            content: Text(
              errorMessage,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
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
            SizedBox(height: 20.0),
            Text(
              'Welcome! Please enter your Name, email, and password to create your account.',
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
            ),
            SizedBox(height: 20.0),
            SignUpForm(
              emailController: emailController,
              passwordController: passwordController,
              fullNameController: fullNameController,
              confirmPasswordController: confirmPasswordController,
              signUpWithEmailAndPassword: signUpWithEmailAndPassword,
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (passwordController.text ==
                        confirmPasswordController.text) {
                      await signUpWithEmailAndPassword(
                        emailController.text,
                        passwordController.text,
                        fullNameController.text, "", // City
                        "", // Country
                        "", // Date of Birth
                        "", // Facebook Link
                        "", // Image Url
                        "", // Instagram Link
                        "", // Region
                        "", // Whatsapp Link);
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Password Error"),
                            content: Text("Passwords do not match"),
                            actions: <Widget>[
                              TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Color(0xff003961))),
                ),
              ],
            ),
            SizedBox(height: 20.0),
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

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.fullNameController,
    required this.confirmPasswordController,
    required this.signUpWithEmailAndPassword,
  }) : super(key: key);

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController fullNameController;
  final TextEditingController confirmPasswordController;
  final Function signUpWithEmailAndPassword;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paddingValue = screenWidth * 0.05;

    return Form(
      child: Column(
        children: [
          buildInputForm('Full Name', false, paddingValue, (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your full name';
            } else if (!isNameValid(value)) {
              return 'Name should not contain numbers';
            }
            return null;
          }, fullNameController),
          buildInputForm('Email Address', false, paddingValue, (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email address';
            } else if (!isValidEmail(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          }, emailController),
          buildInputForm('Your Password', true, paddingValue, (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          }, passwordController),
          buildInputForm('Re-enter Your Password', true, paddingValue, (value) {
            if (value == null || value.isEmpty) {
              return 'Please re-enter your password';
            }
            return null;
          }, confirmPasswordController),
          SizedBox(
              height:
                  20), // Add spacing between form fields and the login button
        ],
      ),
    );
  }

  Padding buildInputForm(
    String label,
    bool pass,
    double paddingValue,
    String? Function(String?)? validator,
    TextEditingController controller,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: paddingValue),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        controller: controller,
        obscureText: pass,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black87),
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
