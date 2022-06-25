import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_sign/pages/accueil.dart';
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
  int indexNav = 1;
  late Widget display = const Accueil();
  final firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //
  //   super.initState();
  // }

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
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
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
                                display = Profile();
                              });
                            },
                            child: Container(
                              child: Icon(
                                Icons.person,
                                color: indexNav == 0 ? Colors.black : Colors.grey,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                indexNav = 1;
                                display = const Accueil();
                              });
                            },
                            child: Container(
                              child: Icon(
                                Icons.home_outlined,
                                color: indexNav == 1 ? Colors.black : Colors.grey,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                indexNav = 2;
                                display = const Page2();
                              });
                            },
                            child: Icon(
                              Icons.settings,
                              color: indexNav == 2 ? Colors.black : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
