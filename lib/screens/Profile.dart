import 'package:flutter/material.dart';
import 'package:guide_go/screens/chat_screen.dart';

class Profile extends StatelessWidget {
  final String uid;
  final String name;
  final String email;
  final String imageUrl;
  final String bio;
  final String usrtype;
  final List<String> imageUrls;
  final String country;
  final String city;
  final String dateOfBirth;
  final String region;

  Profile({
    Key? key,
    required this.uid,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.bio,
    required this.usrtype,
    required this.imageUrls,
    required this.city,
    required this.country,
    required this.dateOfBirth,
    required this.region,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  // Chat button
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            receiverUserID: uid,
                            receiverUserEmail: email,
                            receiverUserName: name,
                            receiverUserphotoUrl: imageUrl, // Updated parameter name
                          ),
                        ),
                      );
                    },
                    icon: ImageIcon(
                      AssetImage("assets/chat-bubble.png"),
                      size: 40,
                    ),
                  ),
                ],
              ),
              // Profile picture
              CircleAvatar(
                radius: 50,
                backgroundImage: imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : AssetImage('assets/man.png') as ImageProvider,
              ),
              SizedBox(height: 16),
              // User name
              Text(
                name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              // User type and icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (usrtype.isNotEmpty)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage(usrtype == "Traveler"
                              ? 'assets/tour-guide (1).png'
                              : 'assets/tour-guide.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  SizedBox(width: 5),
                  Text(
                    usrtype,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Email
              if (email.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email),
                    SizedBox(width: 5),
                    Text(
                      email,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              // Address
              if (country.isNotEmpty && region.isNotEmpty && city.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on),
                    SizedBox(width: 5),
                    Text(
                      "Address: $country, $region, $city",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              SizedBox(height: 5),
              // Date of birth
              if (dateOfBirth.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.date_range),
                    SizedBox(width: 5),
                    Text(
                      dateOfBirth,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              SizedBox(height: 8),
              // Bio
              Text(
                bio,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              // Gallery of images
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
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onLongPress: () {
                        // Handle long press if needed
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey),
                          image: DecorationImage(
                            image: NetworkImage(imageUrls[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
