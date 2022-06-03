import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_sign/pages/page1.dart';
import 'package:easy_sign/pages/page2.dart';
import 'package:easy_sign/pages/page3.dart';
import 'package:easy_sign/pages/page4.dart';
import 'package:easy_sign/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int indexNav = 0;
  late Widget display = const Page1();
  final firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  var user;


  //Variable servant à savoir si c'est un compte privé individuel (0), ou bien un compte rattaché à une entreprise, club etc... (1)
  int accountType = 1;

  @override
  void initState() {
    // TODO: implement initState
    setState(()  {
      // firestoreInstance.collection('users').doc(auth.currentUser!.uid).get().then((value) {
      //   setState(() {
      //     user = value.data();
      //   });
      // });
      //print(user.data());
    });
    super.initState();
  }

  // void updateUser(var usr){
  //   setState(() {
  //     user = usr;
  //   });
  // }
  // void updateUserPdp(String pdp){
  //   setState(() {
  //     user['pdp'] = pdp;
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          display,
          Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                decoration: const BoxDecoration(
                  borderRadius:  const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20),),
                  color: Colors.white,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedPositioned(
                      top: indexNav == 2 ? 15 : -30,
                      left: indexNav == 2 ? MediaQuery.of(context).size.width / 2 - 26 : MediaQuery.of(context).size.width / 2 - 35,
                      duration: const Duration(milliseconds: 150),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            indexNav = 2;
                            display = const Page3();
                          });
                        },
                        child: AnimatedContainer(
                          width: indexNav == 2 ? 52 : 70,
                          height: indexNav == 2 ? 52 : 70,
                          child: AnimatedSize(
                              curve: Curves.easeIn,
                              duration: const Duration(milliseconds: 150),
                              child: Icon(Icons.favorite, color: Colors.white, size: indexNav == 2 ? 25 : 40,)),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(colors: [Color(0xFF53A3FF), Color(0xFFE99FFA)])), duration: const Duration(milliseconds: 150),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                indexNav = 0;
                                display = const Page1();
                              });
                            },
                            child: Container(
                              child: indexNav == 0 ? const Icon(Icons.home_outlined, color: Colors.black,) :  const Icon(Icons.home_outlined, color: Colors.grey),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                indexNav = 1;
                                display = const Page2();
                              });
                            },
                            child: Container(
                              child: indexNav == 1 ? const Icon(Icons.search_outlined, color: Colors.black,)  : const Icon(Icons.search_outlined, color: Colors.grey,),
                            ),
                          ),
                          const SizedBox(width: 50,),
                          InkWell(
                            onTap: () {
                              setState(() {
                                indexNav = 3;
                                display = const Page4();
                              });
                            },
                            child: Container(
                              child: indexNav == 3 ? const Icon(Icons.notifications, color: Colors.black,)  : const Icon(Icons.notifications, color: Colors.grey,),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                indexNav = 4;
                                display = const Profile();
                              });
                            },
                            child: indexNav == 4 ? const Icon(Icons.person, color: Colors.black,)  : const Icon(Icons.person, color: Colors.grey,),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
}
