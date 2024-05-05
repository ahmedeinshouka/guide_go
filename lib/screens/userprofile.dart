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
        child: Column(
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
                  onPressed: () {},
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
                ),SizedBox(height: 30,),
              
            
          Row(children: [Text("Ahmed Einshouka",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)],mainAxisAlignment: MainAxisAlignment.center,),Text("data")],
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        width: double.infinity,
      ),
    ));
  }
  
}
