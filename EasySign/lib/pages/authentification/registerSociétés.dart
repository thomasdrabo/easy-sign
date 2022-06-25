import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_sign/pages/authentification/fill_profile_soci%C3%A9t%C3%A9s.dart';
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

class RegisterSocietes extends StatefulWidget {
  const RegisterSocietes({Key? key}) : super(key: key);

  @override
  _RegisterSocietesState createState() => _RegisterSocietesState();
}

class _RegisterSocietesState extends State<RegisterSocietes> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;

  //Controllers des textfields
  final mailController = TextEditingController();
  final societeNameController = TextEditingController();
  final passwordController = TextEditingController();
  final verifPasswordController = TextEditingController();

  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Créer un compte",
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
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
                controller: societeNameController,
                labelText: "Nom de la société*",
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
                    if (!societeNameController.text.contains(new RegExp(r'[A-Z, a-z]'))) {
                      setState(() {
                        errorMessage = "Merci d'entrer le nom votre société.";
                      });
                    } else {
                      List searchKeywords = [];
                      for (int i = 0; i < societeNameController.text.length; i++) {
                        if (searchKeywords.isEmpty) {
                          searchKeywords.add(societeNameController.text[i].toLowerCase());
                        } else {
                          searchKeywords.add(searchKeywords[searchKeywords.length - 1] + societeNameController.text[i].toLowerCase());
                        }
                      }
                      final status = await FirebaseAuthHelper().createAccount(email: mailController.text, pass: passwordController.text);
                      if (status == AuthResultStatus.successful) {
                        print('SUCCESS');
                        var uid = auth.currentUser!.uid;
                        var date = DateTime.now().toString();
                        FirebaseMessaging messaging = FirebaseMessaging.instance;
                        messaging.getToken().then((value) {
                          firestoreInstance.collection('users').doc(uid).set({
                            "accountCreationDate": date,
                            "accountType": ['société'],
                            "city": null,
                            "description": "",
                            "deviceToken": value,
                            "name": societeNameController.text,
                            "uid": uid,
                            "pdp": "https://firebasestorage.googleapis.com/v0/b/cryptosign-2e67a.appspot.com/o/default-pdp%2Flogo%20easy%20sign.jpg?alt=media&token=9c4928e6-6979-46f3-ab18-10138383254a",
                            "searchKeywords": searchKeywords,
                            "siren": '',
                            "kbis": '',
                            "verified": false
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const FillProfileSociete()),
                          );
                        });
                      } else {
                        final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
                        print('ERROR');
                        setState(() {
                          errorMessage = errorMsg;
                        });
                        print(errorMsg);
                      }
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
    );
  }
}
