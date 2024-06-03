import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:guide_go/firebase_options.dart';
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
import 'screens/userprofile.dart';
import 'screens/Editprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/Gemini.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'screens/consts.dart';
import 'screens/Chatpot_intro.dart';
import 'screens/Pyramids.dart';
import 'screens/Romanamphitheatre.dart';
import 'screens/zeeyarapyramidselite.dart';
import 'screens/Montaggio.dart';
import 'screens/chat_list_page.dart';
import 'package:guide_go/screens/Discover.dart';
import 'screens/weather.dart';

import 'screens/login_phone.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Gemini.init(
    apiKey: GEMINI_API_KEY,
  );

  // Determine the initial route based on the authentication state
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  // Use a ternary operator to set the initial route
  String initialRoute = user != null ? '/' : '/splash';

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const home(),
        '/ageeba': (context) => const Ageeba(),
        '/splash': (context) => const SplashScreen(),
        '/Homepage': (context) => const Intro(),
        '/Login': (context) => LoginScreen(),
        '/SignUp': (context) => SignupScreen(),
        '/manial': (context) => const Manial(),
        '/komona': (context) => const Komona(),
        '/cookdoor': (context) => const CookDoor(),
        "/siwa": (context) => const Siwa(),
        '/maps': (context) => const maps(),
        '/profile': (context) => const Profile(),
        '/editprofile': (context) => const EditProfile(),
        '/Chatbot': (context) => const HomePage(),
        '/Chatbot_intro': (context) => const Chatbot_intro(),
        '/Pyramids': (context) => const Pyramids(),
        '/Roman': (context) => const Romanamphitheatre(),
        '/zeeyara': (context) =>  const Zeeyara (),
        '/Montaggio': (context) => const Montaggio(),
        '/chatList': (context) => ChatListPage(),
        '/login_phone': (context) => Loginphone(),
        '/weather':(context) => const WeatherScreen(),
        '/discover':(context) =>  DiscoverIndependentsScreen(),
      },
    );
  }
}
