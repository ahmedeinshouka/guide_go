import 'package:flutter/material.dart';
import 'package:guide_go/widgets/Login_form.dart';
import 'SignUp.dart';

class LoginScreen extends StatelessWidget {
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0,fontFamily: "LilitaOne",),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            LoginForm(),
            SizedBox(height: 20),
            Row(
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
