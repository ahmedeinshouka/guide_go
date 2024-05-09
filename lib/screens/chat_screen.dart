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
  const ChatScreen(
      {required this.receiverUserID,
      required this.receiverUserEmail,
      required this.receiverUserName});

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

  void sendMessage() async { // Remove the imageUrl parameter
  if (_messageController.text.isNotEmpty) {
    await _chatService.sendMessage(
        widget.receiverUserID, _messageController.text);
    _messageController.clear();
  }
}

void sendImage() async {
  // اختيار الصورة أو الفيديو من الجهاز
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  
  if (pickedFile != null) {
    // حفظ الصورة أو الفيديو في Firebase Storage
    Reference ref = FirebaseStorage.instance.ref().child('chat_media/${DateTime.now().toString()}');
    UploadTask uploadTask = ref.putFile(File(pickedFile.path));
    
    uploadTask.then((res) async {
      // استخراج رابط الصورة أو الفيديو من Firebase Storage
      // ignore: unused_local_variable
      String imageUrl = await res.ref.getDownloadURL();
      
      // إرسال الرابط إلى الشات
      sendMessage(); // Call sendMessage without passing imageUrl
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
                  onSendPressed: sendMessage, // Pass sendMessage without imageUrl
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
          return const Center(
              child:
                  CircularProgressIndicator()); // Show a loading indicator while loading messages
        }
        return ListView(
          reverse:
              true, // Reverse the ListView to show the latest message at the bottom
          children: snapshot.data!.docs.map<Widget>((document) {
            return buildMessageItem(document);
          }).toList(),
        );
      },
    );
  }

  Widget buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // Align the messages to the right if the sender is the current user, otherwise to the left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          mainAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            TextBubble(
              message: data['message'],
              timestamp: '',
              isSender: true,
              isreceiver: true,
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
  final TextStyle? senderTextStyle;
  final TextStyle? receiverTextStyle;
  final Color? senderBackgroundColor;
  final Color? receiverBackgroundColor;
  final bool isSender;
  final bool isreceiver;

  const TextBubble({
    required this.message,
    required this.timestamp,
    this.senderTextStyle,
    this.receiverTextStyle,
    this.senderBackgroundColor,
    this.receiverBackgroundColor,
    this.isSender = true,
    required this.isreceiver,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: isSender
            ? Colors.blue
            : isreceiver
                ? Colors.black
                : Colors.white,
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
            style: const TextStyle(fontSize: 10.0, color: Colors.grey),
          ),
        ],
      ),
    );
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

  // Convert to a map
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

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final Function() onSendPressed;

  const ChatInput({required this.controller, required this.onSendPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Type your message',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: (text) {},
            onSubmitted: (text) {
              onSendPressed();
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: onSendPressed,
        ),
      ],
    );
  }
}

class ChatService extends ChangeNotifier {
  // get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SEND MESSAGE
  Future<void> sendMessage(String receiverId, String message) async {
    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
    );

    // construct chat room id from current user id and receiver id (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // sort the ids (this ensures the chat room id is always the same for any pair)
    String chatRoomId = ids.join(
        "_"); // combine the ids into a single string to use as a chat room id

    // add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // GET MESSAGES
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    // construct chat room id from user ids (sorted to ensure it matches the id used when sending)
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