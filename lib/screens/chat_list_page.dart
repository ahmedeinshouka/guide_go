
import 'package:flutter/material.dart';

import 'package:guide_go/screens/UserList.dart';

class ChatListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search functionality (implement later)
            },
          ),
        ],
      ),
      body: UserList(),
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
        )
    );
  }
}