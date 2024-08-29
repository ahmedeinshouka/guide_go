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

    final ratings = ratingsSnapshot.data()?['ratings'] as List<dynamic>? ?? [];
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
            SizedBox(height: screenHeight * 0.02),
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
            SizedBox(height: screenHeight * 0.02),
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
                    final fullName = (user['fullName'] as String?)?.toLowerCase() ?? '';
                    final email = (user['email'] as String?)?.toLowerCase() ?? '';
                    final city = (user['city'] as String?)?.toLowerCase() ?? '';
                    final country = (user['country'] as String?)?.toLowerCase() ?? '';
                  
                    final searchLower = _searchText.toLowerCase();
                    final addressLower = _addressText.toLowerCase();
                    final interestLower = _interestText.toLowerCase();

                    // Filter out the current user
                    if (user['uid'] == _currentUser?.uid) {
                      return false;
                    }

                    bool matchesSearch = fullName.contains(searchLower) || email.contains(searchLower);
                    bool matchesAddress = city.contains(addressLower) || country.contains(addressLower);
                

                    return matchesSearch && matchesAddress ;
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

                          if (user.isEmpty) {
                            return SizedBox.shrink();
                          }

                          List<String> imageUrls = [];
                          try {
                            imageUrls = List<String>.from(user['imageGallery'] ?? []);
                          } catch (e) {
                            print("Error fetching imageGallery: $e");
                          }

                          double rating = user['rating'] ?? 0.0;

                          if (_ratingText.isNotEmpty && rating < double.parse(_ratingText)) {
                            return SizedBox.shrink();
                          }

                          return TourGuideCard(
                            name: user['fullName'] ?? '', // Handle missing fullName
                            email: user['email'] ?? '', // Handle missing email
                            imageUrl: user['photoUrl'] ?? '', // Handle missing photoUrl
                            bio: user['bio'] ?? '', // Handle missing bio
                            usrtype: user['userType'] ?? '', // Handle missing userType
                            imageUrls: imageUrls,
                            country: user['country'] ?? '', // Handle missing country
                            city: user['city'] ?? '', // Handle missing city
                            dateOfBirth: user['dateOfBirth'] ?? '', // Handle missing dateOfBirth
                            region: user['region'] ?? '', // Handle missing region
                            uid: user['uid'] ?? '', // Handle missing uid
                            rating: double.parse(rating.toStringAsFixed(1)),
                            phoneNumber: user['phoneNumber'] ?? '', // Handle missing phoneNumber
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
      try {
        final userData = user.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic> and check for null

        // Check if userData is null or if required fields are missing
        if (userData == null ||
            !userData.containsKey('uid') ||
            !userData.containsKey('fullName') ||
            !userData.containsKey('email') ||
            !userData.containsKey('photoUrl') ||
            !userData.containsKey('bio') ||
            !userData.containsKey('userType') ||
            !userData.containsKey('country') ||
            !userData.containsKey('city') ||
            !userData.containsKey('dateOfBirth') ||
            !userData.containsKey('region') ||
            !userData.containsKey('phoneNumber')) {
          continue; // Skip this user if any required field is missing
        }

        double rating = await _getUserRating(userData['uid'] as String);
        userList.add({
          'uid': userData['uid'],
          'fullName': userData['fullName'],
          'email': userData['email'],
          'photoUrl': userData['photoUrl'],
          'bio': userData['bio'],
          'userType': userData['userType'],
          'imageGallery': userData['imageGallery'] ?? [], // Handle missing imageGallery
          'country': userData['country'],
          'city': userData['city'],
          'dateOfBirth': userData['dateOfBirth'],
          'region': userData['region'],
          'phoneNumber': userData['phoneNumber'],
          'rating': rating,
        });
      } catch (e) {
        print("Error processing user data: $e");
        continue; // Skip the user if there's an error
      }
    }

    userList.sort((a, b) => b['rating'].compareTo(a['rating']));

    return userList;
  }
}
