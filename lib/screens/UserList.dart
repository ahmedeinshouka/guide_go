import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_screen.dart';

class UserList extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
        final users = snapshot.data!.docs
            .where((doc) => doc['email'] != currentUserEmail)
            .toList();

        return ListView(
          children: users
              .map<Widget>((doc) => _buildUserListItem(context, doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(BuildContext context, DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        leading: CircleAvatar(
          // Here you can load the user's profile image from Firestore or any other source
          // For simplicity, I'm using a placeholder avatar
          child: Icon(Icons.person),
        ),
        title: Text(data['Full Name']), // Display the user's name instead of email
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                receiverUserID: data['uid'],
                receiverUserEmail: data['email'],
                receiverUserName: data['Full Name'], 
                receiverUserImageURL:data['image'], // Pass the user's name
              ),
            ),
          );
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
