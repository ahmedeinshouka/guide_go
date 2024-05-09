import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1st_screen/chat_screen.dart';


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
          // هنا يمكنك تحميل الصورة الشخصية لكل مستخدم من قاعدة البيانات أو من أي مصدر آخر
          backgroundImage: NetworkImage('رابط_الصورة_الشخصية'),
        ),
        title: Text(data['email']),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                receiverUserID: data['uid'],
                receiverUserEmail: data['email'], receiverUserName: data['Full Name'],
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