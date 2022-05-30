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
import 'fill_profile.dart';



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
              Text("Bienvenue sur Easy-sign,", style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),),
            ],
          ),
          SizedBox(height: 15,),
          Container(
            height: 50,
              child: UI_simple_textfield(controller: mailController, labelText: "E-mail",)),
          SizedBox(height: 15,),
          Container(
            height: 50,
              child: UI_simple_textfield(controller: passwordController, labelText: "Mot de passe", obscureText: true,)),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Visibility(
                visible: errorMessage != '',
                child: Text(errorMessage, style: const TextStyle(color: Colors.red),)
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: UI_gradient_button(title: "Se connecter", onPressed: () async {
              final status = await FirebaseAuthHelper().login(
                  email: mailController.text, pass: passwordController.text);
              if (status == AuthResultStatus.successful) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              } else {
                final errorMsg = AuthExceptionHandler.generateExceptionMessage(
                    status);
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
            child: Text("Mot de passe oublié ?", style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontSize: 14,
              ),
            ),),
          ),

          SizedBox(height: 40,),
          UI_rounded_icon_button(title: "Continuer avec Google", onPressed: () {
            signInWithGoogle().then((result) {
              if (result != null) {
                var resultSplitForUid =
                result.split(" ");
                var uid = resultSplitForUid[
                resultSplitForUid.length -
                    1]
                    .substring(
                    0,
                    resultSplitForUid[
                    resultSplitForUid
                        .length -
                        1]
                        .length -
                        1);
                firestoreInstance
                    .collection("users")
                    .doc(uid)
                    .get()
                    .then((value) {
                  if (value.data() == null) {
                    var resultSplitForVar =
                    result.split(",");
                    var uid = auth.currentUser!.uid;
                    var date = DateTime.now().toString();
                    var image = resultSplitForVar[7].split(": ")[1];
                    FirebaseMessaging messaging = FirebaseMessaging.instance;
                    messaging.getToken().then((value) {
                      firestoreInstance
                          .collection('users')
                          .doc(uid)
                          .set({
                        "accountCreationDate": date,
                        "birthday": null,
                        "city": null,
                        "description" : "Salut, je suis nouveau sur l'application ! ✌️",
                        "deviceToken": value,
                        "firstName": "User",
                        "id": uid,
                        "interest": null,
                        "isPublic": true,
                        "lastName": Random().nextInt(10000).toString(),
                        "pdp": image,
                        "pseudo": null,
                        "type": 'Free',
                        "searchKeywords" : null,
                        "swipeCity" : null,
                        "swipeInterest" : null,
                        "swipeRange" : 12.0,
                        "swipeType" : 'Tout',
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FillProfile(googleOrApple : true, googleImg: image,)),
                      );
                    });
                  } else {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const Home()));
                  }
                });
              }
            });
          }, icon: "assets/icons/iconGoogle.svg"),
          SizedBox(height: 20,),
          UI_rounded_icon_button(title: "Continuer avec Apple", onPressed: () async {
            final appleIdCredential =
                await SignInWithApple
                .getAppleIDCredential(
              scopes: [
                AppleIDAuthorizationScopes.email,
                AppleIDAuthorizationScopes
                    .fullName,
              ],
            );
            final oAuthProvider =
            OAuthProvider('apple.com');
            final credential =
            oAuthProvider.credential(
              idToken:
              appleIdCredential.identityToken,
              accessToken: appleIdCredential
                  .authorizationCode,
            );
            await FirebaseAuth.instance
                .signInWithCredential(credential)
                .then((result) {
              if (result != null) {
                var uid = result.user!.uid;
                firestoreInstance
                    .collection("users")
                    .doc(uid)
                    .get()
                    .then((value) {
                  if (value.data() == null) {
                    var date =
                    DateTime.now().toString();
                    FirebaseMessaging messaging = FirebaseMessaging.instance;
                    messaging.getToken().then((value) {
                      firestoreInstance
                          .collection('users')
                          .doc(uid)
                          .set({
                        "accountCreationDate": date,
                        "birthday": null,
                        "city": null,
                        "description": "Salut, je suis nouveau sur l'application ! ✌️",
                        "deviceToken": value,
                        "firstName": "User",
                        "uid": uid,
                        "interest": null,
                        "isPublic": true,
                        "lastName": Random().nextInt(10000).toString(),
                        "pdp": "https://firebasestorage.googleapis.com/v0/b/cryptosign-2e67a.appspot.com/o/default-pdp%2Flogo%20easy%20sign.jpg?alt=media&token=9c4928e6-6979-46f3-ab18-10138383254a",
                        "pseudo": null,
                        "type": 'Free',
                        "searchKeywords": null,
                        "swipeCity": null,
                        "swipeInterest": null,
                        "swipeRange": 12.0,
                        "swipeType": 'Tout',
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FillProfile(googleOrApple : true,)),
                      );
                    });
                  } else {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const Home()));
                  }
                });
              }
            });
          }, icon: "assets/icons/appleIcon.svg")
        ],
      ),
    );
  }
}
