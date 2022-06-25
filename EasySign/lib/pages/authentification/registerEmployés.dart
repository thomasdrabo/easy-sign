import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_sign/pages/authentification/fill_profile_employ%C3%A9s.dart';
import 'package:easy_sign/pages/home.dart';
import 'package:easy_sign/services/authHelpers/auth-exception-handler.dart';
import 'package:easy_sign/services/authHelpers/auth-status-enum.dart';
import 'package:easy_sign/services/authHelpers/auth.dart';
import 'package:easy_sign/services/authHelpers/firebase-auth-helper.dart';
import 'package:easy_sign/widgets/buttons/ui_gradient_button.dart';
import 'package:easy_sign/widgets/buttons/ui_rounded_icon_button.dart';
import 'package:easy_sign/widgets/textFields/ui_simple_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class RegisterEmployes extends StatefulWidget {
  const RegisterEmployes({Key? key}) : super(key: key);

  @override
  _RegisterEmployesState createState() => _RegisterEmployesState();
}

class _RegisterEmployesState extends State<RegisterEmployes> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;

  //Controllers des textfields
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final verifPasswordController = TextEditingController();
  bool type = false;

  String errorMessage = '';



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
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Créer un compte employé',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Container(
                height: 50,
                child: UI_simple_textfield(
                  controller: mailController,
                  labelText: "E-mail*",
                )),
            const SizedBox(
              height: 15,
            ),
            Container(
                height: 50,
                child: UI_simple_textfield(
                  controller: passwordController,
                  labelText: "Mot de passe*",
                  obscureText: true,
                )),
            const SizedBox(
              height: 15,
            ),
            Container(
                height: 50,
                child: UI_simple_textfield(
                  controller: verifPasswordController,
                  labelText: "Confirmer le mot de passe*",
                  obscureText: true,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Intervenant',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: !type ? Colors.black : Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
                Switch(
                    value: type,
                    onChanged: (value) {
                      setState(() {
                        type = !type;
                      });
                    }),
                Text(
                  'Superviseur',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: type ? Colors.black : Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Visibility(
                  visible: errorMessage != '',
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: UI_gradient_button(
                  title: "Suivant",
                  onPressed: () async {
                    if (passwordController.text == verifPasswordController.text) {
                      List searchKeywords = [];
                      String name = "User " + Random().nextInt(10000).toString();
                      for (int i = 0; i < name.length; i++) {
                        if (searchKeywords.isEmpty) {
                          searchKeywords.add(name[i].toLowerCase());
                        } else {
                          searchKeywords.add(searchKeywords[searchKeywords.length - 1] + name[i].toLowerCase());
                        }
                      }
                      final status = await FirebaseAuthHelper().createEmployeAccount(email: mailController.text, pass: passwordController.text);
                      if (status[0] == AuthResultStatus.successful) {
                        print('SUCCESS');
                        String uid = status[1];
                        var date = DateTime.now().toString();
                        FirebaseMessaging messaging = FirebaseMessaging.instance;
                        messaging.getToken().then((value) {
                          firestoreInstance.collection('users').doc(status[1]).set({
                            "accountCreationDate": date,
                            "city": null,
                            "deviceToken": value,
                            "name": name,
                            "uid": uid,
                            "searchKeywords": searchKeywords,
                            "accountType": type ? ['superviseur'] : ['intervenant'],
                            "description": "",
                            "pdp": "https://firebasestorage.googleapis.com/v0/b/cryptosign-2e67a.appspot.com/o/default-pdp%2Flogo%20easy%20sign.jpg?alt=media&token=9c4928e6-6979-46f3-ab18-10138383254a",
                            "verified": false,
                            "entreprise" : user['uid'],
                          });

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => FillProfileEmployes(uid : uid)),
                          );
                        });
                      } else {
                        final errorMsg = AuthExceptionHandler.generateExceptionMessage(status[0]);
                        print('ERROR');
                        setState(() {
                          errorMessage = errorMsg;
                        });
                        print(errorMsg);
                      }
                    } else {
                      setState(() {
                        errorMessage = 'Les mots de passe ne correspondent pas.';
                      });
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
