import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class Ageeba extends StatefulWidget {
  const Ageeba({super.key});

  @override
  State<Ageeba> createState() => _AgeebaState();
}

class _AgeebaState extends State<Ageeba> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _reviewController = TextEditingController();
  Future<void>? _launched;
  String? _editingReviewId;
  String? _userName;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _userName = userDoc['fullName'];
          _photoUrl = userDoc['photoUrl'];
        });
      } else {
        setState(() {
          _userName = user.email;
          _photoUrl = user.photoURL;
        });
      }
    }
  }

  Future<void> _launchInBrowserView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $url');
    }
  }

  void _addReview() async {
    if (_reviewController.text.isNotEmpty && _userName != null) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firestore.collection('ageeba_reviews').add({
          'review': _reviewController.text,
          'timestamp': FieldValue.serverTimestamp(),
          'userId': user.uid,
          'userName': _userName,
          'photoUrl': _photoUrl,
          'likes': [],
        });
        _reviewController.clear();
      }
    }
  }

  void _updateReview(String reviewId) async {
    if (_reviewController.text.isNotEmpty) {
      await _firestore.collection('ageeba_reviews').doc(reviewId).update({
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
      await _firestore.collection('ageeba_reviews').doc(reviewId).delete();
    }
  }

  void _toggleLike(String reviewId, List likes) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final isLiked = likes.contains(userId);

      if (isLiked) {
        _firestore.collection('ageeba_reviews').doc(reviewId).update({
          'likes': FieldValue.arrayRemove([userId])
        });
      } else {
        _firestore.collection('ageeba_reviews').doc(reviewId).update({
          'likes': FieldValue.arrayUnion([userId])
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Uri toLaunch = Uri(
      scheme: 'https',
      host: 'www.lonelyplanet.com',
      path: '/egypt/mediterranean-coast/marsa-matruh/attractions/agiba-beach/a/poi-sig/1426585/355236',
    );

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
                              image: AssetImage("assets/ageeba-4748877.jpg"),
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
                              overlayColor:
                                  MaterialStatePropertyAll(Colors.amber),
                              backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 255, 255, 255),
                              ),
                              shadowColor:
                                  MaterialStatePropertyAll(Colors.grey),
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
                              "Ageeba Mountains",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const Text(
                              "“There's no words can describe that place\n"
                              "than its name (Ageeba) that mean amazing because\n"
                              "it is God's gift and gave it all the beauty that\n"
                              "has never been in another place.”",
                              maxLines: 4,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Services in Ageeba Mountains",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          "assets/414462087_668597158763555_1544068293350259189_n.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  height: 80,
                                  width: 68,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(width: 10),
                                        const Text(
                                          "Kamona",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        DecoratedBox(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(32),
                                            color: const Color.fromRGBO(
                                                234, 232, 232, 0.759),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Row(
                                              children: const [
                                                Icon(
                                                  Icons.restaurant,
                                                  color: Colors.grey,
                                                  size: 14,
                                                ),
                                                Text(
                                                  "Restaurant",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 40),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              "/komona",
                                            );
                                          },
                                          style: const ButtonStyle(
                                            fixedSize: MaterialStatePropertyAll(
                                              Size(10, 10),
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                        Text(
                                          "Marsa Matrouh, Egypt",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: const [
                                        Icon(Icons.star),
                                        Text("4.0"),
                                        Text(
                                          " |36 Reviews|",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: const [
                        SizedBox(width: 25),
                        Text(
                          "Reviews:",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22.0, 0, 22.0, 0),
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
                            .collection('ageeba_reviews')
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
