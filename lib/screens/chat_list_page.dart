import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_screen.dart';
import 'UserList.dart'; // Importing UserList from the same directory

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  String? _searchText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: UserSearchDelegate());
            },
          ),
        ],
      ),
      body: UserList(searchText: _searchText), // Pass _searchText here
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
              onPressed: () {
                // Check if the current route is not the chatList screen
                if (ModalRoute.of(context)?.settings.name != '/chatList') {
                  Navigator.pushNamed(context, "/chatList");
                }
              },
              icon: const ImageIcon(
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
    );
  }
}

class UserSearchDelegate extends SearchDelegate<String> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }
        final currentUserEmail = _auth.currentUser?.email;
        List<DocumentSnapshot> users = snapshot.data!.docs
            .where((doc) =>
                (doc.data() as Map<String, dynamic>).containsKey('email') &&
                doc['email'] != currentUserEmail)
            .toList();

        // Filter users based on query
        if (query.isNotEmpty) {
          users = users.where((user) {
            String fullName =
                (user.data() as Map<String, dynamic>)['fullName'] ?? '';
            return fullName.toLowerCase().contains(query.toLowerCase());
          }).toList();
        }

        return ListView(
          children: users
              .map<Widget>((doc) => _buildUserListItem(context, doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(BuildContext context, DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    Widget leadingWidget;

    // Check if photoUrl is not null or empty
    if (data['photoUrl'] != null && data['photoUrl'].isNotEmpty) {
      // Use container with decoration to make image circular
      leadingWidget = CircleAvatar(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(data['photoUrl']),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    } else {
      // If photoUrl is null or empty, use person icon
      leadingWidget = CircleAvatar(
        child: Icon(Icons.person),
      );
    }

    return ListTile(
      leading: leadingWidget,
      title: Text(data['fullName'] ?? ''), // Display the user's name instead of email
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              receiverUserID: data['uid'] ?? '',
              receiverUserEmail: data['email'] ?? '',
              receiverUserName: data['fullName'] ?? '',
              receiverUserphotoUrl: data['photoUrl'] ?? '', // Pass the user's name
            ),
          ),
        );
      },
    );
  }
}
