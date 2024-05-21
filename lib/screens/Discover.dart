import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'TourGuideCard.dart';

class DiscoverIndependentsScreen extends StatefulWidget {
  @override
  _DiscoverIndependentsScreenState createState() => _DiscoverIndependentsScreenState();
}

class _DiscoverIndependentsScreenState extends State<DiscoverIndependentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });

    // Get the current user
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.02), // Add space above the search bar
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for tour guides and services offers',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.1),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Add space between search bar and container
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
      
                  final users = snapshot.data!.docs;
                  final filteredUsers = users.where((user) {
                    final fullName = user['fullName'].toLowerCase();
                    final email = user['email'].toLowerCase();
                    final searchLower = _searchText.toLowerCase();

                    // Filter out the current user
                    if (user['uid'] == _currentUser?.uid) {
                      return false;
                    }

                    return fullName.contains(searchLower) || email.contains(searchLower);
                  }).toList();
      
                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
      
                      // Fetch imageGallery field from user document
                      List<String> imageUrls = [];
                      try {
                        imageUrls = List<String>.from(user['imageGallery']);
                      } catch (e) {
                        print("Error fetching imageGallery: $e");
                      }
      
                      // Parse rating from String to double
                      double rating = 0.0;
                      try {
                        rating = double.parse(user['rating']);
                      } catch (e) {
                        print("Error parsing rating: $e");
                      }

                      return TourGuideCard(
                        name: user['fullName'],
                        email: user['email'],
                        imageUrl: user['photoUrl'] ?? '', // Handle null imageUrl
                        bio: user['bio'],
                        usrtype: user['userType'],
                        imageUrls: imageUrls,
                        country: user['country'],
                        city: user['city'],
                        dateOfBirth: user['dateOfBirth'],
                        region: user['region'], // Pass the image URLs,
                        uid: user['uid'],
                        rating: rating,
                        phoneNumber:user['phoneNumber'],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          shadowColor: Colors.white,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 10),
              IconButton(
                highlightColor: Colors.amber,
                onPressed: () {
                  // Check if the current route is not the home screen
                  if (ModalRoute.of(context)?.settings.name != '/') {
                    Navigator.popAndPushNamed(context, "/");
                  }
                },
                icon: const ImageIcon(
                  AssetImage("assets/icons8-home-page-32.png"),
                  size: 40,
                ),
              ),
              const SizedBox(width: 20),
              Container(color: Colors.black),
              IconButton(
                highlightColor: Colors.amber,
                onPressed: () {
                  if (ModalRoute.of(context)?.settings.name != '/discover') {
                    Navigator.pushNamed(context, '/discover');
                  }
                },
                icon: const Icon(
                  Icons.people_alt_rounded,
                  size: 40,
                ),
              ),
              const SizedBox(width: 10),
              const SizedBox(width: 10),
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
              const SizedBox(width: 10),
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
      ),
    );
  }
}
