
import 'package:flutter/material.dart';
import 'package:flutter_application_1st_screen/UserList.dart';

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
            const SizedBox(width: 10),
            IconButton(
              highlightColor: Colors.amber,
              onPressed: () {},
              icon: const Icon(Icons.home),
              iconSize: 40,
            ),
            const SizedBox(width: 20),
            Container(color: Colors.black),
            IconButton(
              highlightColor: Colors.amber,
              onPressed: () {},
              icon: const Icon(Icons.people_alt_rounded, size: 40),
            ),
            const SizedBox(width: 20),
            IconButton(
              highlightColor: Colors.amber,
              onPressed: () {},
              icon: const Icon(Icons.favorite),
              iconSize: 40,
            ),
            const SizedBox(width: 20),
            IconButton(
              highlightColor: Colors.amber,
              onPressed: () {},
              icon: const Icon(Icons.chat),
              iconSize: 40,
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}