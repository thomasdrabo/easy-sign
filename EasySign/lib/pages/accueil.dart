import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_sign/pages/authentification/registerEmploy%C3%A9s.dart';
import 'package:easy_sign/services/authHelpers/firebase-auth-helper.dart';
import 'package:easy_sign/widgets/buttons/ui_gradient_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../wrapper.dart';

class Accueil extends StatefulWidget {
  const Accueil({Key? key}) : super(key: key);

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;

  var user;
  void _getUserInfo() {
    firestoreInstance.collection('users').doc(auth.currentUser!.uid).get().then((userDoc) {
      setState(() {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Accueil',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: user['accountType'][0] == 'société' ? buildSociete() : buildEmploye()),
        ),
      ),
    );
  }

  @override
  // TODO: implement widget
  Widget buildSociete() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterEmployes()),
                );
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 2 - 16,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromRGBO(13, 66, 126, 0.2), // variable qui choisie la couleur de bordure par quand on saisie du text
                      width: 1.5),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Center(
                  child: Text(
                    'Créer un employé',
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  Widget buildEmploye() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text('Bonjour ' + user['name'] + '.'),
          ),
        ],
      );
}
