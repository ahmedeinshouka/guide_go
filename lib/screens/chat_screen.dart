import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final String receiverUserID;
  final String receiverUserEmail;
  final String receiverUserName;
  final String receiverUserImageURL;

  const ChatScreen({
    required this.receiverUserID,
    required this.receiverUserEmail,
    required this.receiverUserName,
    required this.receiverUserImageURL,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late final ChatService _chatService;
  late final FirebaseAuth _firebaseAuth;

  @override
  void initState() {
    super.initState();
    _chatService = ChatService();
    _firebaseAuth = FirebaseAuth.instance;
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverUserID,
        _messageController.text,
      );
      _messageController.clear();
    }
  }

  void sendImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('chat_media/${DateTime.now().toString()}');
      UploadTask uploadTask = ref.putFile(File(pickedFile.path));

      uploadTask.then((res) async {
        String imageUrl = await res.ref.getDownloadURL();
        sendMessage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserName),
      ),
      body: Column(
        children: [
          Expanded(
            child: buildMessageList(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ChatInput(
                    controller: _messageController,
                    onSendPressed: sendMessage,
                  ),
                ),
                IconButton(
                  onPressed: sendImage,
                  icon: Icon(Icons.image),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        widget.receiverUserID,
        _firebaseAuth.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          reverse: true,
          children: snapshot.data!.docs.map<Widget>((document) {
            return buildMessageItem(document);
          }).toList(),
        );
      },
    );
  }

  Widget buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var isSender = (data['senderId'] == _firebaseAuth.currentUser!.uid);

    return Container(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isSender)
              CircleAvatar(
                backgroundImage: NetworkImage(widget.receiverUserImageURL),
              ),
            TextBubble(
              message: data['message'],
              timestamp: '',
              isSender: isSender,
              isReceiver: !isSender,
            ),
          ],
        ),
      ),
    );
  }
}

class TextBubble extends StatelessWidget {
  final String message;
  final String timestamp;
  final bool isSender;
  final bool isReceiver;

  const TextBubble({
    required this.message,
    required this.timestamp,
    required this.isSender,
    required this.isReceiver,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: isSender ? Colors.blue : Colors.grey[300], // Sender message color: Blue, Receiver message color: Grey
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(color: isSender ? Colors.white : Colors.black),
          ),
          Text(
            timestamp,
            style: TextStyle(fontSize: 10.0, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final Function() onSendPressed;

  const ChatInput({
    required this.controller,
    required this.onSendPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              suffix: IconButton(
                onPressed: onSendPressed,
                icon: Icon(Icons.send),
              ),
              hintText: 'Type your message',
              border: OutlineInputBorder(
                gapPadding: 5,
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            onChanged: (text) {},
            onSubmitted: (text) {
              onSendPressed();
            },
          ),
        ),
      ],
    );
  }
}

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  const Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.timestamp,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
