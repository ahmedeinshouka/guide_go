import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:lottie/lottie.dart';
class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
    final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _currentUser;
  late String _displayName = '';
  late String _email = '';
  late String _imageUrl = '';
  late String _whatsappUrl = '';
  late String _facebookUrl = '';
  late String _instagramUrl = '';


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
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: IconButton(
            highlightColor: Color(0000),
            onPressed: () {
              Navigator.pushNamed(context, "/Chatbot_intro");
            },
            icon: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            "assets/OIG1.5eQC_asL3LveGgBC.jpeg",
                          ),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(20)),
                  width: 70,
                  height: 70,
                ),
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: SvgPicture.asset(
                    "assets/circle_small_filled_icon_200777 (1).svg",
                    color: Colors.green,
                    height: 60,
                  ),
                )
              ],
            )),
        backgroundColor: const Color.fromRGBO(255, 252, 252, 1),
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [Positioned(
                  right:7 ,top:10,
                  child: GestureDetector(
                      child:  CircleAvatar(
                        backgroundImage: 
                      _imageUrl.isNotEmpty ? NetworkImage(_imageUrl) : null,
                  child: _imageUrl.isEmpty
                      ? Icon(Icons.person, size:40) // Use placeholder icon
                      : null,
                        radius: 40,
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, "/profile");
                      },
                    ),),
                  Row(
                    children: [
                      Column(
                        children: [
                         Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Hello👋 ",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w900),
                              ),
                              Text(
                                _displayName,
                                style: TextStyle(overflow: TextOverflow.clip,
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.mail,
                                color: Colors.grey[600],
                              ),
                              Text(
                                _email,
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w900),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 85,height: 113,
                      ),
                      
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    width: 360,
                    alignment: Alignment.center,
                    child: LottieBuilder.network(
                      "https://lottie.host/3dcdea97-c01c-40e4-9912-28d24e10f2d6/FxPs3sa4Zr.json",
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 0,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Sugessted Destinitions",
                    style: TextStyle(fontFamily: "LilitaOne", fontSize: 25),
                  ),
                  Icon(Icons.place)
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/manial");
                          },
                          child: Container(
                            height: 206,
                            width: 161,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(255, 0, 0, 0),
                                border: Border.all(color: Colors.black),
                                image: const DecorationImage(
                                    image: AssetImage(
                                        "assets/c9871822e93c31e18b16aa95a1944ae6.jpg"),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                        Positioned(
                          top: 120,
                          left: 20,
                          child: Container(
                            height: 66,
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18)),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Prince Mohamed Ali Palace",
                                  style: TextStyle(
                                      fontSize: 8, fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.location_on,
                                      size: 12,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      "Al Manial",
                                      style: TextStyle(
                                          fontSize: 9, color: Colors.grey),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: 12,
                                    ),
                                    Text(
                                      "4.4",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      " | 6 Reviews",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.grey),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/ageeba');
                          },
                          child: Container(
                            height: 206,
                            width: 161,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(255, 0, 0, 0),
                                border: Border.all(color: Colors.black),
                                image: const DecorationImage(
                                    image:
                                        AssetImage("assets/ageeba-4748877.jpg"),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                        Positioned(
                          top: 120,
                          left: 20,
                          child: Container(
                            height: 66,
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18)),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Ageeba",
                                      style: TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.location_on,
                                      size: 12,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      "Marsa matrouh, Egypt",
                                      style: TextStyle(
                                          fontSize: 9, color: Colors.grey),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: 12,
                                    ),
                                    Text(
                                      "4.0",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Divider(
                                      height: 2,
                                      thickness: 1,
                                    ),
                                    Text(
                                      " | 5 Reviews",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.grey),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/Roman');
                          },
                          child: Container(
                            height: 206,
                            width: 161,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(255, 0, 0, 0),
                                border: Border.all(color: Colors.black),
                                image: const DecorationImage(
                                    image: AssetImage(
                                        "assets/The-Roman-amphitheatre.jpg"),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                        Positioned(
                          top: 120,
                          left: 20,
                          child: Container(
                            height: 66,
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18)),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "The Roman Amphitheatre",
                                  style: TextStyle(
                                      fontSize: 8, fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.location_on,
                                      size: 12,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      "Alexandria,Egypt",
                                      style: TextStyle(
                                          fontSize: 9, color: Colors.grey),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: 12,
                                    ),
                                    Text(
                                      "4.9",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      " | 8 Reviews",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.grey),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/Pyramids");
                          },
                          child: Container(
                            height: 206,
                            width: 161,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(255, 0, 0, 0),
                                border: Border.all(color: Colors.black),
                                image: const DecorationImage(
                                    image: AssetImage(
                                        "assets/nada-habashy-zruwsJh-lOI-unsplash.jpg"),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                        Positioned(
                          top: 120,
                          left: 20,
                          child: Container(
                            height: 66,
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18)),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "The Great Pyramid",
                                  style: TextStyle(
                                      fontSize: 8, fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.location_on,
                                      size: 12,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      "Giza,Egypt",
                                      style: TextStyle(
                                          fontSize: 9, color: Colors.grey),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: 12,
                                    ),
                                    Text(
                                      "5",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      " | 9 Reviews",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.grey),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              const Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "People Liked",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/siwa");
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage("assets/z_siwaoasis-_2787.jpg"),
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      height: 86,
                      width: 86,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "Siwa Oasis",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w800),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey[200]),
                              width: 80,
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.park,
                                    color: Colors.grey[800],
                                  ),
                                  const Text(
                                    "Parks",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        const Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.grey,
                            ),
                            Text(
                              "siwa ,Egypt",
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                        const Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            Text(
                              "4.0",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                            Text(
                              "| 36 Reviews | ",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              "20.0€",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                            Text(
                              "/night",
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "   Discover Around your location",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/maps");
                    },
                    icon: Icon(
                      Icons.location_searching,
                      color: Colors.white,
                    ),
                    style: ButtonStyle(
                      overlayColor: MaterialStatePropertyAll(Colors.amber),
                      backgroundColor: MaterialStatePropertyAll(Colors.grey),
                    ),
                  ),
                  SizedBox(
                    width: 1,
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/maps");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 345,
                      width: 300,
                      alignment: Alignment.center,
                      child: LottieBuilder.network(
                        "https://lottie.host/c327b7a9-7e9a-4d4c-a582-37a6081594a1/8BT93NTwnS.json",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
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
                    // Check if the current route is not the home screen
    if (ModalRoute.of(context)?.settings.name != '/') {
      Navigator.popAndPushNamed(context, "/");
    }
                  },
                  icon: const ImageIcon(
                    AssetImage(
                      "assets/icons8-home-page-32.png",
                    ),
                    size: 40,
                  )),
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
                  )),
              const SizedBox(
                width: 10,
              ),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                  highlightColor: Colors.amber,
                  onPressed: () {
                    // Check if the current route is not the chatList screen
    if (ModalRoute.of(context)?.settings.name != '/chatList') {
      Navigator.pushNamed(context, "/chatList");
    }
                  },
                  icon: const ImageIcon(
                    AssetImage("assets/chat.png"),
                    size: 40,
                  )),
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
}
