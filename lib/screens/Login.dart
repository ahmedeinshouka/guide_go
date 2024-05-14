import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:guide_go/screens/SignUp.dart';
import 'login_phone.dart';

class LoginScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    Future<void> signInWithEmailAndPassword(String email, String password) async {
      if (email.isEmpty || password.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text("Login Error"),
              content: Text(
                'An error occurred during sign in. Please make sure you have entered both email and password.',
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
        return;
      }

      try {
        // Check if the user exists in Firestore
        final QuerySnapshot result = await _firestore.collection('users').where('email', isEqualTo: email).get();
        final List<DocumentSnapshot> documents = result.docs;
        if (documents.isEmpty) {
          // Email not found in Firestore
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text("Login Error"),
                content: Text(
                  'The email entered is not registered. Please check your email address or sign up.',
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
          return;
        }

        // Email found in Firestore, now check password
        final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // After successful login, navigate to the chat list page
        Navigator.pushReplacementNamed(context, '/');
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'wrong-password':
            errorMessage = 'The password you entered is incorrect. Please check your password and try again.';
            break;
          default:
            errorMessage = 'An error occurred during sign in. Please check your password.';
            break;
        }
        
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text("Login Error"),
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

    Future<User?> signInWithGoogle() async {
      try {
        final GoogleSignInAccount? gUser = await GoogleSignIn().signIn(); // أضف علامة '=' بين gUser و await
        // obtain auth details from request
        final GoogleSignInAuthentication gAuth = await gUser!.authentication; // أضف علامة '=' بين gAuth و await
        // create a new credential for user
        final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken!,
          idToken: gAuth.idToken!,
        );
        // finally, let's sign in
        final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential); // أضف علامة '=' بين authResult و await
        final User? user = authResult.user;
        return user;
      } catch (error) {
        print(error);
        return null;
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
                      fontFamily: "LilitaOne"),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50), // add spacing between fields
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            48)), // to make the text field box-shaped
                  ),
                ),
                SizedBox(height: 25),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            48)), // to make the text field box-shaped
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await signInWithEmailAndPassword(
                        emailController.text,
                        passwordController.text,
                      );
                    } catch (e) {
                      // An error occurred
                      print('Error during login: $e');
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xff003961)),
                  ),
                  child: SizedBox(
                    child: Text(
                      'Login',
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
                    Container(
                      width: MediaQuery.of(context).size.width /
                          3, // Adjust the width as needed
                      child: Divider(
                        height: 1,
                        color: Colors.black,
                        thickness: 5,
                      ),
                    ),
                    Text(
                      " OR ",
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width /
                          3, // Adjust the width as needed
                      child: Divider(
                        height: 1,
                        color: Colors.black,
                        thickness: 5,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        // تسجيل الدخول باستخدام Google
                        User? user = await signInWithGoogle();
                        if (user != null) {
                          // إضافة المستخدم إلى قاعدة البيانات أو تنفيذ إجراءات إضافية هنا
                          // يمكنك تحديث الرسائل حسب الحاجة
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Google Sign-In Successful'),
                            ),
                          );
                          // الانتقال إلى الصفحة المناسبة بعد تسجيل الدخول
                          Navigator.pushReplacementNamed(context, '/');
                        } else {
                          // فشل تسجيل الدخول باستخدام Google
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Google Sign-In Failed'),
                            ),
                          );
                        }
                      },
                      icon: SvgPicture.asset("assets/icons8-google-48.svg"),
                      splashRadius: 30,
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(CircleBorder())),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login_phone');
                        },
                        icon: Icon(
                          Icons.phone,
                          size: 40,
                        ))
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          MaterialPageRoute(
                              builder: (context) => SignupScreen()),
                        );
                      },
                      child: const Text(
                        'Signup',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationThickness: 1),
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
