import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ageeba extends StatelessWidget {
  const ageeba({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 47,
                    ),
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(34),
                              image: const DecorationImage(
                                  image: AssetImage(
                                    "assets/ageeba-4748877.jpg",
                                  ),
                                  fit: BoxFit.cover)),
                          width: 341,
                          height: 363,
                        ),
                        Positioned(
                          top: 15,
                          left: 24,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(40)),
                            height: 45.74,
                            width: 46.0,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 28,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 33,
                                ),
                                Text(
                                  "Marsa matrouh, Egypt",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                Text(
                                  "5.0",
                                  style: TextStyle(fontSize: 19),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Ageeba Mountains",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w900),
                            ),
                            Text(
                              "“There's no words can describe that place than its \n name (Ageeba) that mean amazing because it is God \n is gift and gave it all the beautiful that never been in \n other place.“ ",
                              maxLines: 4,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Services in Ageeba Mountains",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 20),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/photo7jpg.jpg"),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(14)),
                                  height: 80,
                                  width: 68,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [SizedBox(width: 10,),Text("Kamona",style: TextStyle(fontSize:20,fontWeight: FontWeight.bold ),),SizedBox(width: 20,),Container(child: Row(children: [Icon(Icons.restaurant,color:  Colors.grey[600],),Text("Resturant",style: TextStyle(color: Colors.grey[600]),)],),decoration: BoxDecoration(borderRadius: BorderRadius.circular(32),color: Color.fromARGB(235, 255, 255, 255)),padding: EdgeInsets.all(5),),ElevatedButton(onPressed: (){}, child: Icon(Icons.arrow_forward_ios_rounded,size: 20,),style: ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(5, 50),),shape: MaterialStatePropertyAll(OvalBorder(eccentricity: 1),),),)],
                                    )
                                  ,Row(children: [Icon(Icons.location_on,color: Colors.grey,size: 20,),Text("Marsa matrouh, Egypt",style: TextStyle(fontSize: 12,color: Colors.grey),)],),Row(
                                    children: [Icon(Icons.star),Text("4.0"),Text(" |36 Reviews|",style: TextStyle(color: Colors.grey),)],
                                  )],
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 25,
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: 329,
                  right: 15,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 255, 255, 255)),
                      shadowColor: MaterialStatePropertyAll(Colors.grey),
                      shape: MaterialStatePropertyAll(CircleBorder()),
                      iconSize: MaterialStatePropertyAll(20),
                      iconColor: MaterialStatePropertyAll(Colors.black),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Icon(
                        Icons.favorite_border,
                        size: 50,
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
