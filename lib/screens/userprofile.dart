import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;
  String _displayName = '';
  String _email = '';
  String _photoUrl = '';
  String _phoneNumber = '';
  String _country = '';
  String _city = '';
  String _dateOfBirth = '';
  String _region = '';
  String _userType = '';
  final ImagePicker _imagePicker = ImagePicker();
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      _getUserData();
      _fetchImagesFromFirestore();
    }
  }

  Future<void> _fetchImagesFromFirestore() async {
    try {
      // Fetch gallery images URLs
      QuerySnapshot gallerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('imageGallery')
          .get();
      List<String> urls = gallerySnapshot.docs
          .map((doc) => doc['imageUrl'] as String)
          .toList();
      setState(() {
        _imageUrls = urls;
      });
    } catch (e) {
      print('Error fetching images: $e');
    }
  }

  Future<void> _pickImage({required bool isProfileImage}) async {
    try {
      final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        String downloadURL = await _uploadImageToFirebase(imageFile, isProfileImage: isProfileImage);
        setState(() {
          _imageUrls.add(downloadURL);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _getUserData() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> userData =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_currentUser!.uid)
              .get();

      if (userData.exists) {
        setState(() {
          _displayName = userData['fullName'] ?? '';
          _email = userData['email'] ?? '';
          _phoneNumber = userData['phoneNumber'] ?? '';
          _country = userData['country'] ?? '';
          _city = userData['city'] ?? '';
          _dateOfBirth = userData['dateOfBirth'] ?? '';
          _region = userData['region'] ?? '';
          _userType = userData['userType'] ?? '';

          _photoUrl = userData['photoUrl'] ?? '';
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _uploadImage(File image) async {
    try {
      if (_auth.currentUser == null) {
        print('User is not authenticated. Please sign in.');
        return;
      }

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask.whenComplete(() => null);
      String downloadURL = await storageReference.getDownloadURL();

      DocumentReference userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid);
      userRef.collection('imageGallery').add({'imageUrl': downloadURL});

      setState(() {
        _imageUrls.add(downloadURL);
      });
    } catch (e) {
      if (e is FirebaseException) {
        print('Firebase Storage Error: ${e.code} - ${e.message}');
      } else {
        print('Error uploading image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 40),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/editprofile');
                      },
                      icon: Icon(Icons.settings, size: 35),
                      highlightColor: Colors.amber,
                    )
                  ],
                ),
                CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _photoUrl.isNotEmpty ? NetworkImage(_photoUrl) : null,
                  child: _photoUrl.isEmpty ? Icon(Icons.person, size: 80) : null,
                  radius: 80,
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _displayName,
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_userType.isNotEmpty)
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage(_userType == "Traveler"
                                ? 'assets/tour-guide (1).png'
                                : 'assets/tour-guide.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    SizedBox(width: 5),
                    Text(
                      _userType,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.email_rounded, size: 35),
                    ),
                    Text(
                      _email,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                if (_country.isNotEmpty && _region.isNotEmpty && _city.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.location_on),
                      Text(
                        "Add: $_country, $_region, $_city",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                SizedBox(height: 5),
                if (_dateOfBirth.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.date_range),
                      Text(
                        _dateOfBirth,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
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
                    itemCount: _imageUrls.length,
                    itemBuilder: (context, index) {
                      return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey),
                image: DecorationImage(
                  image: NetworkImage(_imageUrls[index]),
                  fit: BoxFit.cover,
                ),
              ),
            )
            ;
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          shadowColor: Colors.white,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 10,
              ),
              IconButton(
                  highlightColor: Colors.amber,
                  onPressed: () {
                    // Check if the current route is not the home screen
    if (ModalRoute.of(context)?.settings.name != '/') {
      Navigator.popAndPushNamed(context, "/");
    }
                  },
                  icon: const ImageIcon(
                    AssetImage(
                      "assets/icons8-home-page-32.png",
                    ),
                    size: 40,
                  )),
              const SizedBox(
                width: 20,
              ),
              Container(
                color: Colors.black,
              ),
              IconButton(
                  highlightColor: Colors.amber,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.people_alt_rounded,
                    size: 40,
                  )),
              const SizedBox(
                width: 10,
              ),
              const SizedBox(
                width: 10,
              ),
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
                  )),
              const SizedBox(
                width: 10,
              ),
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
        floatingActionButton: FloatingActionButton(backgroundColor: Colors.grey[100],shape: CircleBorder(),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text('Choose from gallery'),
                        onTap: () async {
                          final pickedFile =
                              await _imagePicker.pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            File imageFile = File(pickedFile.path);
                            _uploadImage(imageFile);
                            Navigator.pop(context);
                          }
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.camera_alt),
                        title: Text('Take a photo'),
                        onTap: () async {
                          final pickedFile =
                              await _imagePicker.pickImage(source: ImageSource.camera);
                          if (pickedFile != null) {
                            File imageFile = File(pickedFile.path);
                            _uploadImage(imageFile);
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Icon(Icons.add_a_photo),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (url.isNotEmpty) {
      try {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      } catch (e) {
        print('Error launching URL: $e');
      }
    } else {
      print('URL is empty');
    }
  }

  Future<String> _uploadImageToFirebase(File image,
      {bool isProfileImage = false}) async {
    try {
      if (_auth.currentUser == null) {
        print('User is not authenticated. Please sign in.');
        return '';
      }

      String fileName = image.path.split('/').last;
      Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();

      DocumentReference userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid);
      userRef.collection('imageGallery').add({'imageUrl': downloadURL});

      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }
}
