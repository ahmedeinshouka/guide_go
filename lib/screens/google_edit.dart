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
  String _whatsappLink = '';
  String _instagramLink = '';
  String _facebookLink = '';
  File? _imageFile;
  final picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _unsavedChanges = false;

  bool _validateEmail(String email) {
    RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegex.hasMatch(email);
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _unsavedChanges = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_unsavedChanges) {
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Discard Changes?'),
              content: Text('Are you sure you want to discard your changes?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Discard'),
                ),
              ],
            ),
          );
        }
        return true;
      },
      child: Scaffold(
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
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) => _name = value!,
                  onChanged: (_) => _unsavedChanges = true,
                ),
                // Other form fields...
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      saveChangesToFirestore();
                      if (_password.isNotEmpty) {
                        _auth.currentUser!.updatePassword(_password);
                      }
                    }
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            ),
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
    if (_imageFile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(_auth.currentUser!.uid + '.jpg');
      await storageRef.putFile(_imageFile!);
      photoUrl = await storageRef.getDownloadURL();
    }

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final userData = await transaction.get(userRef);
        if (userData.exists) {
          transaction.update(userRef, {
            'fullName': _name,
            'email': _email,
            'password': _password,
            'dateOfBirth': _dateOfBirth,
            'country': _country,
            'region': _region,
            'city': _city,
            'whatsappLink': _whatsappLink,
            'instagramLink': _instagramLink,
            'facebookLink': _facebookLink,
            'photoUrl': photoUrl,
          });
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
