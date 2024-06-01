import 'package:flutter/material.dart';
import 'package:guide_go/utils/theme/app_colors.dart';
import 'Profile.dart';

class TourGuideCard extends StatefulWidget {
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
  final String uid;
  final double rating;
  final String phoneNumber;

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
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _TourGuideCardState createState() => _TourGuideCardState();
}

class _TourGuideCardState extends State<TourGuideCard> {
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
              name: widget.name,
              email: widget.email,
              imageUrl: widget.imageUrl,
              bio: widget.bio,
              usrtype: widget.usrtype,
              imageUrls: widget.imageUrls,
              country: widget.country,
              city: widget.city,
              dateOfBirth: widget.dateOfBirth,
              region: widget.region,
              uid: widget.uid,
              rating: widget.rating,
              phoneNumber: widget.phoneNumber,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: screenHeight * 0.02), // Add space between cards
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
                  backgroundImage: widget.imageUrl.isNotEmpty
                      ? NetworkImage(widget.imageUrl)
                      : AssetImage('assets/man.png') as ImageProvider, // Use default icon if no image
                ),
                SizedBox(width: screenWidth * 0.05),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.name,
                            style: TextStyle(
                              fontSize: screenWidth * 0.06,
                              fontWeight: FontWeight.bold,
                            ),
                          ),SizedBox(width: 11,),
                          if (widget.usrtype.isNotEmpty)
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                  image: AssetImage(widget.usrtype == "Traveler"
                                      ? 'assets/tour-guide (1).png'
                                      : 'assets/tour-guide.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        widget.email,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        widget.bio,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.grey,
                        ),
                        maxLines: null, // Allow the text to wrap to multiple lines
                        overflow: TextOverflow.visible,
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
                                    name: widget.name,
                                    email: widget.email,
                                    imageUrl: widget.imageUrl,
                                    bio: widget.bio,
                                    usrtype: widget.usrtype,
                                    imageUrls: widget.imageUrls,
                                    country: widget.country,
                                    city: widget.city,
                                    dateOfBirth: widget.dateOfBirth,
                                    region: widget.region,
                                    uid: widget.uid,
                                    rating: widget.rating,
                                    phoneNumber: widget.phoneNumber,
                                  ),
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
                          SizedBox(width: 5),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber),
                              Text('${widget.rating.toStringAsFixed(1)}')
                            ],
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
