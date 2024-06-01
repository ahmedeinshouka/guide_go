import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:guide_go/screens/ImageViewScreen';
import 'chat_screen.dart';
import 'package:photo_view/photo_view.dart';

class Profile extends StatelessWidget {
  final String uid;
  final String name;
  final String email;
  final String imageUrl;
  final String bio;
  final String usrtype;
  final List<String> imageUrls;
  final String country;
  final String city;
  final String dateOfBirth;
  final String region;
  final double rating;
  final String phoneNumber;

  Profile({
    Key? key,
    required this.uid,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.bio,
    required this.usrtype,
    required this.imageUrls,
    required this.city,
    required this.country,
    required this.dateOfBirth,
    required this.region,
    required this.rating,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            receiverUserID: uid,
                            receiverUserEmail: email,
                            receiverUserName: name,
                            receiverUserphotoUrl: imageUrl,
                          ),
                        ),
                      );
                    },
                    icon: ImageIcon(
                      AssetImage("assets/chat-bubble.png"),
                      size: 40,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageViewScreen(
                        imageUrl: imageUrl,
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: imageUrl.isNotEmpty
                      ? NetworkImage(imageUrl)
                      : AssetImage('assets/man.png') as ImageProvider,
                ),
              ),
              SizedBox(height: 16),
              Text(
                name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (usrtype.isNotEmpty)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage(usrtype == "Traveler"
                              ? 'assets/tour-guide (1).png'
                              : 'assets/tour-guide.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  SizedBox(width: 5),
                  Text(
                    usrtype,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              if (email.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email),
                    SizedBox(width: 5),
                    Text(
                      email,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              if (country.isNotEmpty && region.isNotEmpty && city.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on),
                    SizedBox(width: 5),
                    Text(
                      "Address: $country, $region, $city",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              SizedBox(height: 5),
              if (phoneNumber.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone),
                    Text(
                      phoneNumber,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              SizedBox(height: 5),
              if (dateOfBirth.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.date_range),
                    SizedBox(width: 5),
                    Text(
                      dateOfBirth,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              SizedBox(height: 8),
              if (bio.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "“$bio”",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              SizedBox(height: 4),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('ratings')
                    .doc(uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text("No ratings yet.");
                  }
                  final ratings = snapshot.data!['ratings'] as List<dynamic>;
                  double totalRating = 0;
                  final uniqueRaters = <String, double>{};
                  for (var rating in ratings) {
                    uniqueRaters[rating['userId']] = rating['rating'];
                  }
                  for (var rating in uniqueRaters.values) {
                    totalRating += rating;
                  }
                  double averageRating = uniqueRaters.isEmpty
                      ? 0
                      : totalRating / uniqueRaters.length;

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, color: Colors.amber),
                          SizedBox(width: 5),
                          Text(
                            averageRating.toStringAsFixed(1),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        "${uniqueRaters.length} people rated",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 16),
              RatingBar.builder(
                itemSize: 30,
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (newRating) async {
                  await _updateUserRating(uid, newRating);
                },
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageViewScreen(
                              imageUrl: imageUrls[index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey),
                          image: DecorationImage(
                            image: NetworkImage(imageUrls[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateUserRating(String uid, double newRating) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final ratingDoc =
          FirebaseFirestore.instance.collection('ratings').doc(uid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(ratingDoc);

        if (snapshot.exists) {
          final currentRatings = snapshot.data()!['ratings'] as List<dynamic>;
          bool ratingExists = false;

          for (var i = 0; i < currentRatings.length; i++) {
            if (currentRatings[i]['userId'] == currentUser.uid) {
              currentRatings[i]['rating'] = newRating;
              ratingExists = true;
              break;
            }
          }

          if (!ratingExists) {
            currentRatings.add({
              'userId': currentUser.uid,
              'rating': newRating,
            });
          }

          transaction.update(ratingDoc, {'ratings': currentRatings});
        } else {
          transaction.set(ratingDoc, {
            'ratings': [
              {'userId': currentUser.uid, 'rating': newRating}
            ]
          });
        }
      });

      // Update the overall rating in the user's document
      await _updateOverallRating(uid);
    }
  }

  Future<void> _updateOverallRating(String uid) async {
    final ratingDoc =
        FirebaseFirestore.instance.collection('ratings').doc(uid);

    final snapshot = await ratingDoc.get();

    if (snapshot.exists) {
      final ratings = snapshot.data()!['ratings'] as List<dynamic>;
      double totalRating = 0;
      final uniqueRaters = <String, double>{};

      for (var rating in ratings) {
        uniqueRaters[rating['userId']] = rating['rating'];
      }

      for (var rating in uniqueRaters.values) {
        totalRating += rating;
      }

      double averageRating = uniqueRaters.isEmpty
          ? 0
          : totalRating / uniqueRaters.length;

      // Update the user's overall rating in the user's document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'rating': averageRating});
    }
  }
}
