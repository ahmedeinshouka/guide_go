import 'package:flutter/material.dart';


class home extends StatelessWidget {
  const home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: BottomAppBar(child: Row(children: [Container(color: Colors.amber,),Container(color: Colors.black,)],)),
    );
  }
}