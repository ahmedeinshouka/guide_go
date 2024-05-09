import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                    Icons.arrow_back,
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
          ,Row(children: [IconButton(onPressed: (){}, icon: Icon(Icons.email_rounded,size: 35,)),Text("einshoukaa@gmail.com",style: TextStyle(fontWeight: FontWeight.bold),)],mainAxisAlignment: MainAxisAlignment.center,)],
        ),
      ),floatingActionButton: Row(children: [SizedBox(width: 40,),IconButton(onPressed: (){}, icon:SvgPicture.asset("assets/icons8-whatsapp.svg",color: Colors.green,)),SizedBox(width: 40,),IconButton(onPressed: (){}, icon:SvgPicture.asset("assets/icons8-facebook (2).svg",color: Colors.blue,)),SizedBox(width: 40,),IconButton(onPressed: (){}, icon:SvgPicture.asset("assets/icons8-instagram-100.svg",))],mainAxisAlignment: MainAxisAlignment.center,),
    bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          shadowColor: Colors.white,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 10,
              ),
              IconButton(
                  highlightColor: Colors.amber,
                  onPressed: () {
                    Navigator.pop(context, "/");
                  },
                  icon: const ImageIcon(
                    AssetImage(
                      "assets/icons8-home-page-32.png",
                    ),
                    size: 40,
                  )),
              const SizedBox(
                width: 20,
              ),
              Container(
                color: Colors.black,
              ),
              IconButton(
                  highlightColor: Colors.amber,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.people_alt_rounded,
                    size: 40,
                  )),
              const SizedBox(
                width: 10,
              ),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                  highlightColor: Colors.amber,
                  onPressed: () {},
                  icon: const ImageIcon(
                    AssetImage("assets/chat.png"),
                    size: 40,
                  )),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                highlightColor: Colors.amber,
                onPressed: () {
                  Navigator.pushNamed(context, "/profile");
                },
                icon: const Icon(Icons.person),
                iconSize: 40,
              ),
            ],
          ),
        )));
  }
}
