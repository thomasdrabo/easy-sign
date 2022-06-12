import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/user.dart';
import '../widgets/buttons/ui_gradient_button.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;

  var user;
  void _getUserInfo() {
    firestoreInstance.collection('users').doc(auth.currentUser!.uid).get().then((userDoc) {
      setState((){
        user = userDoc.data();
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    _getUserInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) => Scaffold(
            appBar: AppBar(),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                buildName(),
                const SizedBox(height: 48),
                Center(
                  child: Container(
                    width: 100,
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(1000)),
                        child: Image.network(user['pdp'])
                    ),
                  ),
                ),

                const SizedBox(height: 48),
                buildAbout(),
                const SizedBox(height: 16),
                buildInfos(),
              ],
            )));
  }

  Widget buildName() => Center(
    child: Text(
      user['pseudo'],
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
    ),
  );

  Widget buildAbout() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          user['description'],
          style: const TextStyle(fontSize: 16, height: 1.4),
        ),
      ],
    ),
  );

  Widget buildInfos() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Infos',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          user['firstName'] + ' ' + user['lastName'],
          style: const TextStyle(fontSize: 16, height: 1.4),
        ),
        const SizedBox(height: 16),
        const Text(
          'Superieur',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          "boss boss boss",
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
        const SizedBox(height: 16),
        const Text(
          'Poste',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          "pute pute pute",
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
      ],
    ),
  );
}

