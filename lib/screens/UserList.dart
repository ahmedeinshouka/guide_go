import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'chat_screen.dart';

class UserList extends StatefulWidget {
  final String? searchText;

  UserList({this.searchText});

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Trigger the refresh when dependencies change
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> _fetchUsersWithLastMessage() async {
    final currentUserEmail = _auth.currentUser?.email;
    final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

    List<Map<String, dynamic>> users = usersSnapshot.docs
        .where((doc) => doc['email'] != currentUserEmail)
        .map((doc) => {
              'uid': doc['uid'],
              'fullName': doc['fullName'],
              'email': doc['email'],
              'photoUrl': doc['photoUrl'],
              'lastMessage': null,
              'lastMessageTimestamp': null,
              'isSent': false,
            })
        .toList();

    for (var user in users) {
      final chatRoomId = _getChatRoomId(_auth.currentUser!.uid, user['uid']);
      final messagesSnapshot = await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (messagesSnapshot.docs.isNotEmpty) {
        final lastMessageDoc = messagesSnapshot.docs.first;
        user['lastMessage'] = lastMessageDoc['message'];
        user['lastMessageTimestamp'] = lastMessageDoc['timestamp'];
        user['isSent'] = lastMessageDoc['senderId'] == _auth.currentUser!.uid;
      }
    }

    users.sort((a, b) {
      final timestampA = a['lastMessageTimestamp'];
      final timestampB = b['lastMessageTimestamp'];
      if (timestampA == null && timestampB == null) return 0;
      if (timestampA == null) return 1;
      if (timestampB == null) return -1;
      return timestampB.compareTo(timestampA);
    });

    return users;
  }

  String _getChatRoomId(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    return ids.join("_");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchUsersWithLastMessage(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data ?? [];

        if (widget.searchText != null && widget.searchText!.isNotEmpty) {
          users.retainWhere((user) {
            String fullName = user['fullName'] ?? '';
            return fullName.toLowerCase().contains(widget.searchText!.toLowerCase());
          });
        }

        return ListView(
          children: users.map((user) => _buildUserListItem(context, user)).toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(BuildContext context, Map<String, dynamic> user) {
    Widget leadingWidget;

    if (user['photoUrl'] != null && user['photoUrl'].isNotEmpty) {
      leadingWidget = CircleAvatar(
        backgroundImage: NetworkImage(user['photoUrl']),
      );
    } else {
      leadingWidget = CircleAvatar(
        child: Icon(Icons.person),
      );
    }

    String messagePrefix = user['isSent'] ? 'You: ' : '';
    String lastMessage = user['lastMessage'] ?? 'No messages yet';

    if (lastMessage.startsWith('http')) {
      lastMessage = user['isSent'] ? 'Image sent' : 'Image received';
    }

    return ListTile(
      leading: leadingWidget,
      title: Text(user['fullName'] ?? ''),
      subtitle: Text('$messagePrefix$lastMessage'),
      trailing: user['lastMessageTimestamp'] != null
          ? Text(
              _formatTimestamp(user['lastMessageTimestamp']),
              style: TextStyle(fontSize: 12),
            )
          : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              receiverUserID: user['uid'] ?? '',
              receiverUserEmail: user['email'] ?? '',
              receiverUserName: user['fullName'] ?? '',
              receiverUserphotoUrl: user['photoUrl'] ?? '',
            ),
          ),
        ).then((_) {
          setState(() {}); // Refresh the state when returning from ChatScreen
        });
      },
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final DateTime dateTime = timestamp.toDate();
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(dateTime);
  }
}
