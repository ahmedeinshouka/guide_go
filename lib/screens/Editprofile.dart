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

  bool _validateEmail(String email) {
    RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegex.hasMatch(email);
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
          onPressed: () => Navigator.popAndPushNamed(context, "/profile"),
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
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter your email address';
                  } else if (!_validateEmail(value.trim())) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
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
                initialValue: _whatsappLink,
                decoration: InputDecoration(
                  labelText: 'WhatsApp Link',
                ),
                onChanged: (value) => _whatsappLink = value,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: _instagramLink,
                decoration: InputDecoration(
                  labelText: 'Instagram Link',
                ),
                onChanged: (value) => _instagramLink = value,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: _facebookLink,
                decoration: InputDecoration(
                  labelText: 'Facebook Link',
                ),
                onChanged: (value) => _facebookLink = value,
              ),
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
    String imageUrl = '';
    if (_imageFile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(_auth.currentUser!.uid + '.jpg');
      await storageRef.putFile(_imageFile!);
      imageUrl = await storageRef.getDownloadURL();
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .set({
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
      'imageUrl': imageUrl,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $error')),
      );
    });
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
