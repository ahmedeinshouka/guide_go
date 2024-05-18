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
  late User? _currentUser;
  late String _displayName = '';
  late String _email = '';
  late String _photoUrl = '';
  late String _phoneNumber = '';
  late String _country = '';
  late String _city = '';
  late String _dateOfBirth = '';
  late String _region = '';
  late String _userType = '';
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      _getUserData();
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

          // Check if 'photoUrl' field exists before accessing it
          _photoUrl = userData.exists ? userData["photoUrl"] ?? '' : '';
        });
      } else {
        // Handle case where 'photoUrl' field is missing
        print('Error fetching user data: "photoUrl" field does not exist');
      }
    } catch (e) {
      // Handle other errors (show a SnackBar or a dialog)
      print('Error fetching user data: $e');
    }
  }

  Future<void> _uploadImage(File image) async {
    try {
      // Check if the user is authenticated
      if (_auth.currentUser == null) {
        print('User is not authenticated. Please sign in.');
        return;
      }

      // Proceed with image upload
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask.whenComplete(() => null);
      String downloadURL = await storageReference.getDownloadURL();

      // Update the gallery collection with the new image document
      DocumentReference userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid);
      userRef.collection('imageGallery').add({'imageUrl': downloadURL});

      setState(() {
        // Update UI if necessary
      });
    } catch (e) {
      // Handle exceptions
      if (e is FirebaseException) {
        print('Firebase Storage Error: ${e.code} - ${e.message}');
      } else {
        print('Error uploading image: $e');
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(source: source);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        _uploadImage(imageFile);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  
                  SizedBox(
                    height: 40,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/editprofile');
                    },
                    icon: Icon(
                      Icons.settings,
                      size: 35,
                    ),
                    highlightColor: Colors.amber,
                  )
                ],
              ),
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                backgroundImage:
                    _photoUrl.isNotEmpty ? NetworkImage(_photoUrl) : null,
                child: _photoUrl.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 80,
                      ) // Use placeholder icon
                    : null,
                radius: 80,
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _displayName,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  if (_userType != null && _userType.isNotEmpty)
      Container(
        width: 40, // Adjust width and height as needed
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: _userType == "Traveler"
                ? AssetImage('assets/tour-guide (1).png')
                : AssetImage('assets/tour-guide.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    SizedBox(width: 5),
    Text(
      _userType ?? '', // Use null-aware operator to handle null case
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.grey[700],
      ),
    ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.email_rounded,
                      size: 35,
                    ),
                  ),
                  Text(
                    _email,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            if ( _country.isNotEmpty&& _region.isNotEmpty&& _city.isNotEmpty&&_country!= null&& _region!= null&& _city!= null)
  Row(
    children: [
      Text(
        "Add:${_country ?? ''},${_region ?? ''},${_city ?? ''}",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ],
    mainAxisAlignment: MainAxisAlignment.center,
  ),

              SizedBox(
                height: 5,
              ),
                if (_dateOfBirth != null && _dateOfBirth.isNotEmpty)
              Row(
                children: [
                  Icon(Icons.date_range),
                  Text(
                    _dateOfBirth,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          shadowColor: Colors.white,
          elevation: 0,
          child: Row
(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 10,
              ),
              IconButton(
                highlightColor: Colors.amber,
                onPressed: () {
                  if (ModalRoute.of(context)?.settings.name != '/') {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  }
                },
                icon: ImageIcon(
                  AssetImage(
                    "assets/icons8-home-page-32.png",
                  ),
                  size: 40,
                ),
              ),
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
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                highlightColor: Colors.amber,
                onPressed: () {},
                icon: ImageIcon(
                  AssetImage("assets/chat.png"),
                  size: 40,
                ),
              ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Show options for picking images
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
                          // Pick image from gallery
                          final pickedFile =
                              await _imagePicker.pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            File imageFile = File(pickedFile.path);
                            _uploadImage(imageFile); // Upload the picked image
                            Navigator.pop(context); // Close the bottom sheet
                          }
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.camera_alt),
                        title: Text('Take a photo'),
                        onTap: () async {
                          // Take a photo using the camera
                          final pickedFile =
                              await _imagePicker.pickImage(source: ImageSource.camera);
                          if (pickedFile != null) {
                            File imageFile = File(pickedFile.path);
                            _uploadImage(imageFile); // Upload the taken photo
                            Navigator.pop(context); // Close the bottom sheet
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Icon(Icons.add),
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
        // Handle error (show a SnackBar or a dialog)
      }
    } else {
      print('URL is empty');
      // Handle empty URL case (show a SnackBar or a dialog)
    }
  }

  Future<String> _uploadImageToFirebase(File image,
      {bool isProfileImage = false}) async {
    try {
      // Check if the user is authenticated
      if (_auth.currentUser == null) {
        print('User is not authenticated. Please sign in.');
        return ''; // Return empty string to indicate failure
      }

      String fileName = image.path.split('/').last;
      Reference storageReference =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();

      // Update the gallery collection with the new image document
      DocumentReference userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid);
      userRef.collection('imageGallery').add({'imageUrl': downloadURL});

      // Return the download URL
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return ''; // Return empty string in case of failure
    }
  }
}
