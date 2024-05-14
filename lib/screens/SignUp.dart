import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guide_go/screens/Login.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? selectedType;
  bool isTourGuide = false;
  bool isTraveler = false;
  // تحقق من صحة البريد الإلكتروني
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address.';  // عرض رسالة خطأ إذا كان البريد الإلكتروني فارغًا
    }
    if (!RegExp(r"^[a-zA-Z0-9.a-z_+]*@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
      return 'Please enter a valid email address.';  // عرض رسالة خطأ إذا كان البريد الإلكتروني غير صالح
    }
    return null;
  }

  // تحقق من صحة كلمة المرور
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password.';  // عرض رسالة خطأ إذا كانت كلمة المرور فارغة
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';  // عرض رسالة خطأ إذا كانت كلمة المرور أقل من 6 أحرف
    }
    return null;
  }

  // تحقق من صحة الاسم الكامل
  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name.';  // عرض رسالة خطأ إذا كان الاسم الكامل فارغًا
    }
    return null;
  }

  // إنشاء مستخدم جديد بالبريد الإلكتروني وكلمة المرور والمعلومات الإضافية
  Future<void> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
    String city,
    String country,
    String dateOfBirth,
    String facebookLink,
    String imageUrl,
    String instagramLink,
    String region,
    String whatsappLink,
    String phoneNumber,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'uid': userCredential.user?.uid,
        'email': email,
        'fullName': name,
        'password': password,
        'city': city,
        'country': country,
        'dateOfBirth': dateOfBirth,
        'facebookLink': facebookLink,
        'imageUrl': imageUrl,
        'instagramLink': instagramLink,
        'region': region,
        'whatsappLink': whatsappLink,
        'phoneNumber': phoneNumber,
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // إنشاء مستخدم جديد بالبريد الإلكتروني وكلمة المرور ونوع المستخدم
  Future<UserCredential?> signUpWithEmailandPassword(
      String email, String password, String fullName, String userType) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // بعد إنشاء المستخدم، أنشئ مستندًا جديدًا للمستخدم في مجموعة المستخدمين
      _firestore.collection('users').doc(userCredential.user?.uid).set({
        'uid': userCredential.user?.uid,
        'email': email,
        'fullName': fullName, // استخدم fullName الممرر كمعلمة
        'isTourGuide': userType == "TourGuide",
        'isTraveler': userType == "Traveler",
        'selectedType': userType,
        // أضف المزيد من الحقول حسب الحاجة
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');  // عرض رسالة خطأ إذا كانت كلمة المرور ضعيفة جدًا
      } else if (e.code == 'email-already-in-use') {
        print('The email address is already in use by another account.');  // عرض رسالة خطأ إذا كان البريد الإلكتروني مستخدمًا بالفعل
      } else {
        print('Error during sign up: $e');
      }
      return null; // إشارة فشل
    } catch (e) {
      // التعامل مع الاستثناءات الأخرى
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController fullNameController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Sign up'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.08,
                        fontFamily: "LilitaOne",
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Text(
                    'Welcome! Please enter your Name, email, and password to create your account.',
                    style:
                        TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  TextField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                      errorText: validateFullName(fullNameController.text),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      errorText: validateEmail(emailController.text),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      errorText: validatePassword(passwordController.text),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                      errorText: (confirmPasswordController.text != passwordController.text)
                          ? 'Passwords do not match.'
                          : null,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  RadioListTile(
                    title: Text("I'm a Traveller"),
                    value: "Traveler",
                    groupValue: selectedType,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value as String?;
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
                      });
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
  onPressed: () async {
    String? emailError = validateEmail(emailController.text);
    String? passwordError = validatePassword(passwordController.text);
    String? fullNameError = validateFullName(fullNameController.text);

    if (emailError != null || passwordError != null || fullNameError != null) {
      // عرض رسالة الأخطاء في الواجهة باستخدام SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$emailError\n$passwordError\n$fullNameError',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select user type',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      // عرض رسالة خطأ إذا لم تتطابق كلمتا المرور
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Passwords do not match.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await signUpWithEmailAndPassword(
        emailController.text,
        passwordController.text,
        fullNameController.text,
        "", // City
        "", // Country
        "", // Date of Birth
        "", // Facebook Link
        "", // Image Url
        "", // Instagram Link
        "", // Region
        "", // Whatsapp Link
        "", // Phone Number
      );

      // نجاح عملية التسجيل، التعامل مع التنقل إلى الصفحة التالية
      Navigator.pushReplacementNamed(context, '/Login'); // استبدلها بالمسار المطلوب
    } catch (e) {
      // فشلت عملية التسجيل (يتم التعامل معها في signUpWithEmailAndPassword)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sign up failed: $e',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  },
  child: Text('Sign Up'),
),

                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationThickness: 1,
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
