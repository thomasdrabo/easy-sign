import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_sign/pages/authentification/forget_password.dart';
import 'package:easy_sign/pages/home.dart';
import 'package:easy_sign/services/authHelpers/auth-exception-handler.dart';
import 'package:easy_sign/services/authHelpers/auth-status-enum.dart';
import 'package:easy_sign/services/authHelpers/auth.dart';
import 'package:easy_sign/services/authHelpers/firebase-auth-helper.dart';
import 'package:easy_sign/widgets/buttons/ui_rounded_icon_button.dart';
import 'package:easy_sign/widgets/textFields/ui_simple_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../widgets/buttons/ui_gradient_button.dart';
import 'fill_profile_sociétés.dart';

class Connection extends StatefulWidget {
  const Connection({Key? key}) : super(key: key);

  @override
  _ConnectionState createState() => _ConnectionState();
}

class _ConnectionState extends State<Connection> {
  //Instance firebase
  final firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  //Controllers des textfields
  final mailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isChecked = false;

  //Message d'erreur
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 25, right: 80, left: 80),
            child: Image.asset("assets/icons/logo easy sign.jpg"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Bienvenue sur Easy-sign,",
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
              height: 50,
              child: UI_simple_textfield(
                controller: mailController,
                labelText: "E-mail",
              )),
          SizedBox(
            height: 15,
          ),
          Container(
              height: 50,
              child: UI_simple_textfield(
                controller: passwordController,
                labelText: "Mot de passe",
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
                title: "Se connecter",
                onPressed: () async {
                  final status = await FirebaseAuthHelper().login(email: mailController.text, pass: passwordController.text);
                  if (status == AuthResultStatus.successful) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  } else {
                    final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
                    setState(() {
                      errorMessage = errorMsg;
                    });
                  }
                }),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForgetPassword()),
              );
            },
            child: Text(
              "Mot de passe oublié ?",
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
