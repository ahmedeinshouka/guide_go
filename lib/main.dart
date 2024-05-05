// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/AgeebaMountains.dart';
import 'screens/splash.dart';
import 'package:guide_go/screens/HomePageSc.dart';
import 'package:guide_go/screens/Login.dart';
import 'package:guide_go/screens/SignUp.dart';
import 'package:guide_go/screens/Manialpalace.dart';
import 'package:guide_go/screens/Komona.dart';
import 'screens/cookdoor.dart';
import 'screens/Siwa.dart';
import 'screens/maps.dart';
import'screens/userprofile.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/': (context) => home(),
        '/ageeba': (context) => ageeba(),
        '/splash': (context) => SplashScreen(),
        '/Homepage': (context) => Intro(),
        '/Login': (context) => LoginScreen(),
        '/SignUp': (context) => SignupScreen(),
        '/manial': (context) => Manial(),
        '/komona': (context) => komona(),
        '/cookdoor': (context) => cookdoor(),
        "/siwa": (context) => siwa(),
        '/maps':(context) => maps(),
        '/profile':(context) => profile(),
      },
    );
  }
}
