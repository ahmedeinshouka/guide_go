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
  String _ratingText = "";
  String _addressText = "";
  String _interestText = "";
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

  Future<double> _getUserRating(String uid) async {
    final ratingsSnapshot = await FirebaseFirestore.instance
        .collection('ratings')
        .doc(uid)
        .get();

    if (!ratingsSnapshot.exists) {
      return 0.0;
    }

    final ratings = ratingsSnapshot.data()!['ratings'] as List<dynamic>;
    double totalRating = 0;
    final uniqueRaters = <String, double>{};
    for (var rating in ratings) {
      uniqueRaters[rating['userId']] = rating['rating'];
    }
    for (var rating in uniqueRaters.values) {
      totalRating += rating;
    }
    return uniqueRaters.isEmpty ? 0.0 : totalRating / uniqueRaters.length;
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final ratingController = TextEditingController(text: _ratingText);
        final addressController = TextEditingController(text: _addressText);
        final interestController = TextEditingController(text: _interestText);

        return AlertDialog(
          title: Text('Filters'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ratingController,
                decoration: InputDecoration(
                  hintText: 'Minimum Rating',
                  prefixIcon: Icon(Icons.star),
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  hintText: 'Address (City or Country)',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              TextField(
                controller: interestController,
                decoration: InputDecoration(
                  hintText: 'Interests',
                  prefixIcon: Icon(Icons.interests),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _ratingText = ratingController.text;
                  _addressText = addressController.text;
                  _interestText = interestController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Apply'),
            ),
          ],
        );
      },
    );
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
              child: Row(
                children: [
                  Expanded(
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
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: _showFilterDialog,
                  ),
                ],
              ),
            ),
            Wrap(
              spacing: 8.0,
              children: [
                if (_ratingText.isNotEmpty)
                  Chip(
                    label: Text('Rating: $_ratingText'),
                    onDeleted: () {
                      setState(() {
                        _ratingText = "";
                      });
                    },
                  ),
                if (_addressText.isNotEmpty)
                  Chip(
                    label: Text('Address: $_addressText'),
                    onDeleted: () {
                      setState(() {
                        _addressText = "";
                      });
                    },
                  ),
                if (_interestText.isNotEmpty)
                  Chip(
                    label: Text('Interests: $_interestText'),
                    onDeleted: () {
                      setState(() {
                        _interestText = "";
                      });
                    },
                  ),
              ],
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
                    final city = user['city'].toLowerCase();
                    final country = user['country'].toLowerCase();
                    final bio = user['bio'].toLowerCase();
                    final searchLower = _searchText.toLowerCase();
                    final addressLower = _addressText.toLowerCase();
                    final interestLower = _interestText.toLowerCase();

                    // Filter out the current user
                    if (user['uid'] == _currentUser?.uid) {
                      return false;
                    }

                    bool matchesSearch = fullName.contains(searchLower) || email.contains(searchLower);
                    bool matchesAddress = city.contains(addressLower) || country.contains(addressLower);
                    bool matchesInterest = bio.contains(interestLower);

                    return matchesSearch && matchesAddress && matchesInterest;
                  }).toList();

                  return FutureBuilder<List<Map<String, dynamic>>>(
                    future: _fetchAndSortUsersByRating(filteredUsers),
                    builder: (context, futureSnapshot) {
                      if (futureSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (futureSnapshot.hasError) {
                        return Center(child: Text('Error: ${futureSnapshot.error}'));
                      }

                      final sortedUsers = futureSnapshot.data ?? [];

                      return ListView.builder(
                        itemCount: sortedUsers.length,
                        itemBuilder: (context, index) {
                          final user = sortedUsers[index];

                          // Fetch imageGallery field from user document
                          List<String> imageUrls = [];
                          try {
                            imageUrls = List<String>.from(user['imageGallery']);
                          } catch (e) {
                            print("Error fetching imageGallery: $e");
                          }

                          double rating = user['rating'];

                          // Apply rating filter
                          if (_ratingText.isNotEmpty && rating < double.parse(_ratingText)) {
                            return SizedBox.shrink(); // Skip this user if the rating is lower than the filter
                          }

                          return TourGuideCard(
                            name: user['fullName'],
                            email: user['email'],
                            imageUrl: user['photoUrl'] ?? '', // Handle null imageUrl
                            bio: user['bio'] ?? '', // Handle null bio
                            usrtype: user['userType'],
                            imageUrls: imageUrls,
                            country: user['country'],
                            city: user['city'],
                            dateOfBirth: user['dateOfBirth'],
                            region: user['region'], // Pass the image URLs
                            uid: user['uid'],
                            rating: double.parse(rating.toStringAsFixed(1)),
                            phoneNumber: user['phoneNumber'],
                          );
                        },
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

  Future<List<Map<String, dynamic>>> _fetchAndSortUsersByRating(List<QueryDocumentSnapshot> users) async {
    List<Map<String, dynamic>> userList = [];

    for (var user in users) {
      double rating = await _getUserRating(user['uid']);
      userList.add({
        'uid': user['uid'],
        'fullName': user['fullName'],
        'email': user['email'],
        'photoUrl': user['photoUrl'],
        'bio': user['bio'],
        'userType': user['userType'],
        'imageGallery': user['imageGallery'],
        'country': user['country'],
        'city': user['city'],
        'dateOfBirth': user['dateOfBirth'],
        'region': user['region'],
        'phoneNumber': user['phoneNumber'],
        'rating': rating,
      });
    }

    userList.sort((a, b) => b['rating'].compareTo(a['rating']));

    return userList;
  }
}
