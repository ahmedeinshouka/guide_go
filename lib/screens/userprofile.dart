import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:photo_view/photo_view.dart';
import 'ImageViewScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image/image.dart' as img;

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
  bool _isUploading = false;
  double _uploadProgress = 0.0;

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
      QuerySnapshot gallerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('imageGallery')
          .get();
      List<String> urls =
          gallerySnapshot.docs.map((doc) => doc['imageUrl'] as String).toList();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .update({'imageGallery': urls});

      setState(() {
        _imageUrls = urls;
      });
    } catch (e) {
      print('Error fetching images: $e');
    }
  }

  Future<void> _pickImage({required bool isProfileImage}) async {
    try {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        String downloadURL = await _uploadImageToFirebase(imageFile,
            isProfileImage: isProfileImage);
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

      setState(() {
        _isUploading = true;
        _uploadProgress = 0.0;
      });

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(image);

      uploadTask.snapshotEvents.listen((event) {
        setState(() {
          _uploadProgress =
              (event.bytesTransferred.toDouble() / event.totalBytes.toDouble());
        });
      });

      await uploadTask.whenComplete(() => null);
      String downloadURL = await storageReference.getDownloadURL();

      DocumentReference userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid);
      userRef.collection('imageGallery').add({'imageUrl': downloadURL});

      setState(() {
        _imageUrls.add(downloadURL);
        _isUploading = false;
      });

      await _fetchImagesFromFirestore();
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      if (e is FirebaseException) {
        print('Firebase Storage Error: ${e.code} - ${e.message}');
      } else {
        print('Error uploading image: $e');
      }
    }
  }

  Future<void> _deleteImage(String imageUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('imageGallery')
          .where('imageUrl', isEqualTo: imageUrl)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      setState(() {
        _imageUrls.remove(imageUrl);
      });

      await _fetchImagesFromFirestore();
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  Future<void> _editImage(String oldImageUrl) async {
    try {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File newImageFile = File(pickedFile.path);
        String newDownloadURL = await _uploadImageToFirebase(newImageFile);
        await _deleteImage(oldImageUrl);
        setState(() {
          _imageUrls.remove(oldImageUrl);
          _imageUrls.add(newDownloadURL);
        });

        await _fetchImagesFromFirestore();
      }
    } catch (e) {
      print('Error editing image: $e');
    }
  }

  Future<String> _resizeImage(File image) async {
    try {
      img.Image? originalImage = img.decodeImage(await image.readAsBytes());
      if (originalImage == null) {
        throw Exception('Unable to decode image');
      }
      img.Image resizedImage = img.copyResize(originalImage, width: 600);
      File resizedFile = File(image.path)
        ..writeAsBytesSync(img.encodeJpg(resizedImage, quality: 85));
      return resizedFile.path;
    } catch (e) {
      print('Error resizing image: $e');
      return '';
    }
  }

  Future<String> _uploadImageToFirebase(File image,
      {bool isProfileImage = false}) async {
    try {
      if (_auth.currentUser == null) {
        print('User is not authenticated. Please sign in.');
        return '';
      }

      String resizedImagePath = await _resizeImage(image);
      File resizedImage = File(resizedImagePath);

      String fileName = resizedImage.path.split('/').last;
      Reference storageReference =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(resizedImage);
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

  void _showEditDeleteDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit or Delete Image"),
          content: Text("Would you like to edit or delete this image?"),
          actions: <Widget>[
            TextButton(
              child: Text("Edit"),
              onPressed: () {
                Navigator.of(context).pop();
                _editImage(imageUrl);
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteImage(imageUrl);
              },
            ),
          ],
        );
      },
    );
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
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () async {
                        await _auth.signOut();
                        Navigator.pushReplacementNamed(context, '/splash');
                      },
                    ),
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
                GestureDetector(
                  onTap: () {
                    if (_photoUrl.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ImageViewScreen(imageUrl: _photoUrl),
                        ),
                      );
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        _photoUrl.isNotEmpty ? NetworkImage(_photoUrl) : null,
                    child: _photoUrl.isEmpty ? Icon(Icons.person, size: 80) : null,
                    radius: 80,
                  ),
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
                if (_email.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email),
                      Text(
                        _email,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                if (_country.isNotEmpty && _region.isNotEmpty && _city.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on),
                      Text(
                        "Add: $_country, $_region, $_city",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),SizedBox(height: 5,),if (_phoneNumber.isNotEmpty) Row(mainAxisAlignment: MainAxisAlignment.center,children: [Icon(Icons.phone),Text(_phoneNumber,  style: TextStyle(fontWeight: FontWeight.bold),)],),
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
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ImageViewScreen(imageUrl: _imageUrls[index]),
                            ),
                          );
                        },
                        onLongPress: () {
                          _showEditDeleteDialog(_imageUrls[index]);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey),
                            image: DecorationImage(
                              image: NetworkImage(_imageUrls[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (_isUploading)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text("Uploading Image..."),
                        SizedBox(height: 10),
                        LinearProgressIndicator(value: _uploadProgress),
                      ],
                    ),
                  ),
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
                  if (ModalRoute.of(context)?.settings.name != '/') {
                    Navigator.popAndPushNamed(context, "/");
                  }
                },
                icon: const ImageIcon(
                  AssetImage("assets/icons8-home-page-32.png"),
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
              const SizedBox(
                width: 10,
              ),
              const SizedBox(
                width: 10,
              ),
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
              const SizedBox(
                width: 10,
              ),
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey[100],
          shape: CircleBorder(),
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
                          final pickedFile = await _imagePicker.pickImage(
                              source: ImageSource.gallery);
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
                          final pickedFile = await _imagePicker.pickImage(
                              source: ImageSource.camera);
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
}
