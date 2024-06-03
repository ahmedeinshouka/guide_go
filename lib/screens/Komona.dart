import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:async';


import 'package:url_launcher/url_launcher.dart';


class Komona extends StatefulWidget {
  const Komona({super.key});

  @override
  State<Komona> createState() => _KomonaState();
}

class _KomonaState extends State<Komona> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _reviewController = TextEditingController();
  Future<void>? _launched;
  String? _editingReviewId;

  Future<void> _launchInBrowserView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void _addReview() async {
    if (_reviewController.text.isNotEmpty) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        String userName = userDoc['fullName'];
        String? photoUrl = userDoc['photoUrl'];

        await _firestore.collection('Komona_reviews').add({
          'review': _reviewController.text,
          'timestamp': FieldValue.serverTimestamp(),
          'userId': user.uid,
          'userName': userName,
          'photoUrl': photoUrl,
          'likes': [],
        });
        _reviewController.clear();
      }
    }
  }

  void _updateReview(String reviewId) async {
    if (_reviewController.text.isNotEmpty) {
      await _firestore.collection('Komona_reviews').doc(reviewId).update({
        'review': _reviewController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _reviewController.clear();
      setState(() {
        _editingReviewId = null;
      });
    }
  }

  void _deleteReview(String reviewId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firestore.collection('Komona_reviews').doc(reviewId).delete();
    }
  }

  void _toggleLike(String reviewId, List likes) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final isLiked = likes.contains(userId);

      if (isLiked) {
        _firestore.collection('Komona_reviews').doc(reviewId).update({
          'likes': FieldValue.arrayRemove([userId])
        });
      } else {
        _firestore.collection('Komona_reviews').doc(reviewId).update({
          'likes': FieldValue.arrayUnion([userId])
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Uri toLaunch = Uri(scheme: 'https', host: 'web.facebook.com', path: '/kamona.ag');

    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 47),
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(34),
                            image: const DecorationImage(
                              image: AssetImage("assets/414462087_668597158763555_1544068293350259189_n.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          width: 341,
                          height: 363,
                        ),
                        Positioned(
                          top: 15,
                          left: 24,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            height: 45.74,
                            width: 46.0,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: -20,
                          child: ElevatedButton(
                            onPressed: () => setState(() {
                              _launched = _launchInBrowserView(toLaunch);
                            }),
                            style: const ButtonStyle(
                              overlayColor: MaterialStatePropertyAll(Colors.amber),
                              backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 255, 255, 255),
                              ),
                              shadowColor: MaterialStatePropertyAll(Colors.grey),
                              shape: MaterialStatePropertyAll(CircleBorder()),
                              iconSize: MaterialStatePropertyAll(50),
                              iconColor: MaterialStatePropertyAll(Colors.black),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Icon(
                                Icons.info_rounded,
                                size: 50,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 35),
                    Row(
                      children: [
                        const SizedBox(width: 28),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.location_on,
                                  size: 33,
                                ),
                                Text(
                                  "Marsa Matrouh, Egypt",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 30),
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                Text(
                                  "5.0",
                                  style: TextStyle(fontSize: 19),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Kamona Restaurant",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const Text(
                              "“A beautiful restaurant with oriental decorations\n"
                              "in the heart of Marsa Matrouh. It is a very spacious\n"
                              "restaurant with an area of two floors, which makes\n"
                              "it suitable for large groups of individuals. The\n"
                              "restaurant serves delicious oriental dishes, including\n"
                              "grilled sausage, kofta, kebab, liver, all kinds of rice,\n"
                              "grilled pigeon, and others. The restaurant is also\n"
                              "characterized by quick service and average prices\n"
                              "that suit everyone.“",
                              maxLines: 20,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "      Reviews:",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: TextField(
                        controller: _reviewController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: _editingReviewId == null
                                ? _addReview
                                : () => _updateReview(_editingReviewId!),
                            icon: const Icon(Icons.send),
                          ),
                          hintText: "Add a review",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 200, // Set a specific height for the reviews section
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('Komona_reviews')
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final reviews = snapshot.data!.docs;
                          User? user = FirebaseAuth.instance.currentUser;
                          return ListView.builder(
                            itemCount: reviews.length,
                            itemBuilder: (context, index) {
                              final review = reviews[index];
                              final likes = review['likes'] as List;
                              final isLiked = user != null && likes.contains(user.uid);
                              return ListTile(
                                title: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: review['photoUrl'] != null
                                          ? NetworkImage(review['photoUrl'])
                                          : const AssetImage("assets/man.png") as ImageProvider,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(review['review'])),
                                  ],
                                ),
                                subtitle: Text(review['userName']),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (review['userId'] == user?.uid) ...[
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          setState(() {
                                            _editingReviewId = review.id;
                                            _reviewController.text = review['review'];
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          _deleteReview(review.id);
                                        },
                                      ),
                                    ],
                                    IconButton(
                                      icon: Icon(
                                        isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                                        color: isLiked ? Colors.blue : Colors.grey,
                                      ),
                                      onPressed: () {
                                        _toggleLike(review.id, likes);
                                      },
                                    ),
                                    Text(likes.length.toString()),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            
            ],
          ),
        ),
      ),
    );
  }
}
