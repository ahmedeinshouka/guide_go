import 'package:flutter/material.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
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
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_circle_left,
                    size: 35,
                  ),
                  highlightColor: Colors.amber,
                ),
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
              backgroundImage: AssetImage(
                "assets/DSC_0564 copy.jpg",
              ),
              radius: 80,
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Ahmed Einshouka",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Text("data")
          ],
        ),
      ),
    ));
  }
}
