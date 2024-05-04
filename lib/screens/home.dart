import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui';

import 'package:lottie/lottie.dart';

class home extends StatelessWidget {
  const home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(255, 252, 252, 1),
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      const Row(
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
                            "Name",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w900),
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
                            "email@gmail.com",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w900),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 120,
                  ),
                  GestureDetector(
                    child: const CircleAvatar(
                      backgroundImage: AssetImage("assets/DSC_0564 copy.jpg"),
                      radius: 40,
                    ),
                    onTap: () {},
                  )
                ],
              ),
              const SizedBox(
                height: 0
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [Container(child:  LottieBuilder.network("https://lottie.host/3dcdea97-c01c-40e4-9912-28d24e10f2d6/FxPs3sa4Zr.json",fit: BoxFit.cover,),height: 200,width: 360,alignment: Alignment.center,),
                  
                ],
              ),
              const SizedBox(
                height: 0,
              ),
              const Text(
                "   Discover",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    width: 1,
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.white)),
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.all_inclusive,
                          color: Colors.grey,
                        ),
                        Text(
                          " All",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.white)),
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.museum_outlined,
                          color: Colors.grey,
                        ),
                        Text(
                          " museum",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.white)),
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.park,
                          color: Colors.grey,
                        ),
                        Text(
                          " Parks",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
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
                  )
                ],
              ),
              SizedBox(
                height: 20,
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
              Row(
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
                                  style: TextStyle(fontWeight: FontWeight.w600),
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
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/siwa");
                      },
                      child: Icon(
                        Icons.arrow_right,
                        size: 20,
                      ))
                ],
              )
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
                  onPressed: () {},
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
                  onPressed: () {},
                  icon: const ImageIcon(
                    AssetImage("assets/chat.png"),
                    size: 40,
                  )),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                highlightColor: Colors.amber,
                onPressed: () {},
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
