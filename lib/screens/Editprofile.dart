import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  String _dateOfBirth = '';
  String _country = '';
  String _region = '';
  String _city = '';
  String _bio = ''; // Add this line for the bio
  String userType = '';
  String? selectedType;

  File? _imageFile;
  final picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        print('User is signed in with Google: ${user.displayName}');
        fetchUserData(user.uid);
      } else {
        print('User is not signed in');
      }
    });
  }

  void fetchUserData(String uid) async {
    try {
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userData.exists) {
        setState(() {
          _name = userData['fullName'] ?? '';
          _email = userData['email'] ?? '';
          _dateOfBirth = userData['dateOfBirth'] ?? '';
          _country = userData['country'] ?? '';
          _region = userData['region'] ?? '';
          _city = userData['city'] ?? '';
          _bio = userData['bio'] ?? ''; // Fetch the bio
          userType = userData['userType'] ?? '';
          selectedType = userType;
          print('Fetched userType: $userType');
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Edit Profile',
                style: TextStyle(fontSize: 24.0, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: () => _showImagePicker(context),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _imageFile != null && _imageFile!.existsSync()
                          ? FileImage(_imageFile!)
                          : null,
                  child: _imageFile == null || !_imageFile!.existsSync()
                      ? Icon(Icons.person, size: 50)
                      : null,
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                onSaved: (value) => _email = value!,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: _password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                onSaved: (value) => _password = value!,
                onChanged: (value) => _password = value!,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: _dateOfBirth,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: _country,
                decoration: InputDecoration(
                  labelText: 'Country',
                ),
                onChanged: (value) => _country = value,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: _region,
                decoration: InputDecoration(
                  labelText: 'Region',
                ),
                onChanged: (value) => _region = value,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: _city,
                decoration: InputDecoration(
                  labelText: 'City',
                ),
                onChanged: (value) => _city = value,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: _bio, // Add this field for bio
                decoration: InputDecoration(
                  labelText: 'Bio',
                ),
                onChanged: (value) => _bio = value,
              ),
              const SizedBox(height: 16.0),
              RadioListTile(
                title: Text("I'm a Traveller"),
                value: "Traveler",
                groupValue: selectedType,
                onChanged: (value) {
                  setState(() {
                    selectedType = value as String?;
                    userType = (value as String?)!;
                    print('Selected userType: $userType');
                  });
                },
              ),
              SizedBox(height: 1),
              RadioListTile(
                title: Text("I'm a Tour guide"),
                value: "TourGuide",
                groupValue: selectedType,
                onChanged: (value) {
                  setState(() {
                    selectedType = value as String?;
                    userType = (value as String?)!;
                    print('Selected userType: $userType');
                  });
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(style: ButtonStyle(backgroundColor:MaterialStatePropertyAll(Color(0xff003961))),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    saveChangesToFirestore();
                    if (_password.isNotEmpty) {
                      _auth.currentUser!.updatePassword(_password);
                    }
                  }
                },
                child: const Text('Save Changes',style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take Photo'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> saveChangesToFirestore() async {
    String photoUrl = '';
    if (_auth.currentUser != null) {
      try {
        if (_imageFile != null) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('user_images')
              .child(_auth.currentUser!.uid + '.jpg');
          await storageRef.putFile(_imageFile!);
          photoUrl = await storageRef.getDownloadURL();
        }

        final userRef = FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser!.uid);

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final userData = await transaction.get(userRef);
          if (userData.exists) {
            Map<String, dynamic> dataToUpdate = {};

            if (_name.isNotEmpty) dataToUpdate['fullName'] = _name;
            if (_email.isNotEmpty) dataToUpdate['email'] = _email;
            if (_password.isNotEmpty) dataToUpdate['password'] = _password;
            if (_dateOfBirth.isNotEmpty)
              dataToUpdate['dateOfBirth'] = _dateOfBirth;
            if (_country.isNotEmpty) dataToUpdate['country'] = _country;
            if (_region.isNotEmpty) dataToUpdate['region'] = _region;
            if (_city.isNotEmpty) dataToUpdate['city'] = _city;
            if (_bio.isNotEmpty) dataToUpdate['bio'] = _bio; // Save the bio
            if (photoUrl.isNotEmpty) dataToUpdate['photoUrl'] = photoUrl;
            if (userType.isNotEmpty) dataToUpdate['userType'] = userType;

            transaction.update(userRef, dataToUpdate);
            print('Updated userType: $userType');
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('User is not authenticated. Please sign in again.')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateOfBirth = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
}
