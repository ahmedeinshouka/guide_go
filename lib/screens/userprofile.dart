import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _currentUser;
  late String _displayName = '';
  late String _email = '';
  late String _imageUrl = '';
  late String _whatsappUrl = '';
  late String _facebookUrl = '';
  late String _instagramUrl = '';
  InAppWebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      _getUserData();
    }
  }

Future<void> _getUserData() async {
  try {
    final DocumentSnapshot<Map<String, dynamic>> userData =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .get();

    if (userData.exists) {
      setState(() {
        _displayName = userData['fullName'] ?? '';
        _email = userData['email'] ?? '';
        // Check if 'imageUrl' field exists before accessing it
        _imageUrl = userData.exists ? userData["imageUrl"] ?? '' : '';
        _whatsappUrl = userData["whatsappLink"] ?? '';
        _facebookUrl = userData["facebookLink"] ?? '';
        _instagramUrl = userData["instagramLink"] ?? '';
      });
    } else {
      // Handle case where 'imageUrl' field is missing
      print('Error fetching user data: "imageUrl" field does not exist');
    }
  } catch (e) {
    // Handle other errors (show a SnackBar or a dialog)
    print('Error fetching user data: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 35,
                    ),
                    highlightColor: Colors.amber,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/editprofile');
                    },
                    icon: Icon(
                      Icons.settings,
                      size: 35,
                    ),
                    highlightColor: Colors.amber,
                  )
                ],
              ),
              CircleAvatar(
                backgroundImage:
                    _imageUrl.isNotEmpty ? NetworkImage(_imageUrl) : null,
                child: _imageUrl.isEmpty
                    ? Icon(Icons.person, size: 80) // Use placeholder icon
                    : null,
                radius: 80,
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _displayName,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Text("data"),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.email_rounded,
                      size: 35,
                    ),
                  ),
                  Text(
                    _email,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              )
            ],
          ),
        ),
        floatingActionButton: Row(
          children: [
            SizedBox(
              width: 40,
            ),
            IconButton(
              onPressed: () {
                _launchURL(_whatsappUrl);
              },
              icon: SvgPicture.asset(
                "assets/icons8-whatsapp.svg",
                color: Colors.green,
              ),
            ),
            SizedBox(
              width: 40,
            ),
            IconButton(
              onPressed: () {
                _launchURL(_facebookUrl);
              },
              icon: SvgPicture.asset(
                "assets/icons8-facebook (2).svg",
                color: Colors.blue,
              ),
            ),
            SizedBox(
              width: 40,
            ),
            IconButton(
              onPressed: () {
                _launchURL(_instagramUrl);
              },
              icon: SvgPicture.asset(
                "assets/icons8-instagram-100.svg",
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          shadowColor: Colors.white,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 10,
              ),
              IconButton(
                highlightColor: Colors.amber,
                onPressed: () {
                  if (ModalRoute.of(context)?.settings.name != '/') {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          }
                },
                icon: ImageIcon(
                  AssetImage(
                    "assets/icons8-home-page-32.png",
                  ),
                  size: 40,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                color: Colors.black,
              ),
              IconButton(
                highlightColor: Colors.amber,
                onPressed: () {},
                icon: const Icon(
                  Icons.people_alt_rounded,
                  size: 40,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                highlightColor: Colors.amber,
                onPressed: () {},
                icon: ImageIcon(
                  AssetImage("assets/chat.png"),
                  size: 40,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                highlightColor: Colors.amber,
                onPressed: () {
                  // Check if the current route is not the profile screen
    if (ModalRoute.of(context)?.settings.name != '/profile') {
      Navigator.pushNamed(context, "/profile");
    }
                },
                icon: const Icon(Icons.person),
                iconSize: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (url.isNotEmpty) {
      try {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      } catch (e) {
        print('Error launching URL: $e');
        // Handle error (show a SnackBar or a dialog)
      }
    } else {
      print('URL is empty');
      // Handle empty URL case (show a SnackBar or a dialog)
    }
  }
}
