import 'package:flutter/material.dart';
import 'package:guide_go/utils/theme/app_colors.dart';
import 'Profile.dart';

class TourGuideCard extends StatelessWidget {
  final String name;
  final String email;
  final String imageUrl;
  final String bio;
  final String usrtype;
  List<String> imageUrls = [];
  final String country;
  final String city;
  final String dateOfBirth;
  final String region;
  final String uid;
  final double rating;
  

  TourGuideCard({
    Key? key,
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
    required this.uid,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Profile(
                name: name,
                email: email,
                imageUrl: imageUrl,
                bio: bio,
                usrtype: usrtype,
                imageUrls: imageUrls,
                country: country,
                city: city,
                dateOfBirth: dateOfBirth,
                region: region,
                uid: uid,
                rating: rating),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(
            bottom: screenHeight * 0.02), // Add space between cards
        padding: EdgeInsets.all(screenWidth * 0.05),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: screenWidth * 0.1,
                  backgroundImage: imageUrl.isNotEmpty
                      ? NetworkImage(imageUrl)
                      : AssetImage('assets/man.png')
                          as ImageProvider, // Use default icon if no image
                ),
                SizedBox(width: screenWidth * 0.05),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        bio,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Row(
                        children: [
                          Icon(
                            Icons.account_box_outlined,
                            color: AppColors.primaryColor,
                          ),
                          SizedBox(width: screenWidth * 0.01),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Profile(
                                      name: name,
                                      email: email,
                                      imageUrl: imageUrl,
                                      bio: bio,
                                      usrtype: usrtype,
                                      imageUrls: imageUrls,
                                      country: country,
                                      city: city,
                                      dateOfBirth: dateOfBirth,
                                      region: region,
                                      uid: uid,
                                      rating: rating),
                                ),
                              );
                            },
                            child: Text(
                              'View profile',
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: AppColors.primaryColor,
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
          ],
        ),
      ),
    );
  }
}
