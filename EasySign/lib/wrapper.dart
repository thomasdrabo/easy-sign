import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_sign/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class Wrapper extends StatefulWidget {
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<User1?>(context);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final firestoreInstance = FirebaseFirestore.instance;

    // return either Home or Authenticate widget
    if (auth.currentUser ==  null) {
      //return Login();
      return Home();
    } else {
      return Home();
    }
  }
}
