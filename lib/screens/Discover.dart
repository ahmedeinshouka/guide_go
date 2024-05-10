import 'package:flutter/material.dart';
import 'package:guide_go/utils/theme/app_colors.dart';
import 'SignUp.dart';

class TourGuideCard extends StatelessWidget {
  final String name;
  final String profession;
  final String imageUrl;

  const TourGuideCard({
    Key? key,
    required this.name,
    required this.profession,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: screenWidth * 0.1,
                backgroundImage: AssetImage(imageUrl),
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
                      profession,
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
                              MaterialPageRoute(builder: (context) => SignupScreen()),
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
    );
  }
}

class DiscoverIndependentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Discover Independents',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Add functionality for the search icon
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.02), // Add space above the search bar
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for tour guides and services offers',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.1),
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02), // Add space between search bar and container
          Expanded(
            child: ListView(
              children: [
                TourGuideCard(
                  name: 'Ahmed einshouka',
                  profession: 'Software Engineer, I love to travel with other people',
                  imageUrl: 'assets/images/einshouka.jpeg',
                ),
                SizedBox(height: screenHeight * 0.02), // Add space between cards
                TourGuideCard(
                  name: 'Abdelrhman darwish',
                  profession: 'National car dealer, also I can offer my camera for renting',
                  imageUrl: 'assets/images/abdelrhmandarwish.jpeg',
                ),
                SizedBox(height: screenHeight * 0.02), // Add space between cards
                TourGuideCard(
                  name: 'Ebrahim zaki',
                  profession: 'Photographer, specializing in portrait photography',
                  imageUrl: 'assets/images/ebrahimzaki.jpeg',
                ),
                // Add more TourGuideCard widgets as needed
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shadowColor: Colors.white,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 10),
            IconButton(
              highlightColor: Colors.amber,
              onPressed: () {},
              icon: const Icon(Icons.home),
              iconSize: 30,
            ),
            const SizedBox(width: 20),
            Container(
              color: Colors.black, // Adjust height as needed
            ),
            IconButton(
              highlightColor: Colors.amber,
              onPressed: () {},
              icon: const Icon(Icons.people_alt_rounded),
              iconSize: 30,
            ),
            const SizedBox(width: 20),
            IconButton(
              highlightColor: Colors.amber,
              onPressed: () {},
              icon: const Icon(Icons.favorite),
              iconSize: 30,
            ),
            const SizedBox(width: 20),
            IconButton(
              highlightColor: Colors.amber,
              onPressed: () {},
              icon: const Icon(Icons.chat),
              iconSize: 30,
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
