import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_screen.dart';

class UserList extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String? searchText;

  UserList({this.searchText});

  @override
  Widget build(BuildContext context) {
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

        // Filter users based on searchText
        if (searchText != null && searchText!.isNotEmpty) {
          users = users.where((user) {
            String fullName =
                (user.data() as Map<String, dynamic>)['fullName'] ?? '';
            return fullName.toLowerCase().contains(searchText!.toLowerCase());
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

