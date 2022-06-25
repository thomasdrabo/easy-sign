import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
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
      setState(() {
        user = userDoc.data();
      });
    }).whenComplete(() {
      if (user['accountType'][0] == 'société') {
        _getIntervenantInfo();
        _getSuperviseurInfo();
      } else {
        _getEntrInfo();
      }
    });
  }

  var entr;
  void _getEntrInfo() {
    firestoreInstance.collection('users').doc(user['entreprise']).get().then((entrDoc) {
      setState(() {
        entr = entrDoc.data();
      });
    });
  }

  List intervenants = [];
  void _getIntervenantInfo() {
    firestoreInstance.collection('users').where('entreprise', isEqualTo: auth.currentUser!.uid).where('accountType', arrayContains: 'intervenant').get().then((interDocs) {
      interDocs.docs.forEach((interDoc) {
        setState(() {
          intervenants.add(interDoc.data());
        });
      });
    });
  }

  List superviseurs = [];
  void _getSuperviseurInfo() {
    firestoreInstance.collection('users').where('entreprise', isEqualTo: auth.currentUser!.uid).where('accountType', arrayContains: 'superviseur').get().then((supervDocs) {
      supervDocs.docs.forEach((supervDoc) {
        setState(() {
          superviseurs.add(supervDoc.data());
        });
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
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Profile',
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
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                buildName(),
                const SizedBox(height: 48),
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(1000)),
                        child: Image.network(
                          user['pdp'],
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_pin),
                    Text(
                      user['city'],
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                user['accountType'][0] == 'société' ? buildSociete() : buildEmploye()
              ],
            )));
  }

  Widget buildName() => Center(
        child: Text(
          user['name'],
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ),
      );

  Widget buildSociete() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Description :',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                user['description'] == '' ? 'Pas de description.' : user['description'],
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Superviseurs :',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: superviseurs.length,
                itemBuilder: (context, i) {
                  return Text(
                    superviseurs[i]['name'],
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Intervenants :',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: intervenants.length,
                itemBuilder: (context, i) {
                  return Text(
                    intervenants[i]['name'],
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );

  Widget buildEmploye() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Entreprise :',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                entr['name'],
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
}
