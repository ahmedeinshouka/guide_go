import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Chatbot_intro extends StatefulWidget {
  const Chatbot_intro({super.key});

  @override
  State<Chatbot_intro> createState() => _Chatbot_introState();
}

class _Chatbot_introState extends State<Chatbot_intro> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.black,
                    size: 40,
                  )),
              top: 50,
              left: 9,
            ),
            Positioned(
              child: Text(
                "You AI Guidance",
                style: TextStyle(fontSize: 30, fontFamily: 'LilitaOne'),
              ),
              top: 53,
              left: 100,
            ),
            Positioned(
              child: Text(
                "Using this software you can ask your\n Guide-Go chatbot to help you get more info about\n your distance",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              top: 100,
              left: 25,
            ),
            Positioned(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/OIG1.jpeg"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all()),
                height: 324,
                width: 320,
              ),
              top: 230,
              left: 33,
            ),
            Positioned(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/Chatbot');
                },
                child: SizedBox(
                    width: 300,
                    height: 56,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Continue",
                          style: TextStyle(color: Colors.white, fontSize: 26),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        )
                      ],
                    )),
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.black)),
              ),
              bottom: 50,
              left: 20,
            )
          ],
        ),
      ),
    );
  }
}
