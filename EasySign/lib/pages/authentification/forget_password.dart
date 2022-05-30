import 'dart:async';

import 'package:easy_sign/widgets/buttons/ui_gradient_button.dart';
import 'package:easy_sign/widgets/textFields/ui_simple_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'login.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  final FirebaseAuth auth = FirebaseAuth.instance;

  //Controller du textfield
  final mailController = TextEditingController();

  String errorMessage = '';
  late Timer _timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Se connecter",
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 25, right: 80, left: 80),
              child: Image.asset("assets/icons/logo easy sign.jpg"),
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Mot de passe oublié ?", style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),),
              ],
            ),
            const SizedBox(height: 10,),
            Text("Entrez votre adresse email et consultez votre boite de réception pour réinitialiser votre mot de passe", style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.black,
                fontSize: 14,
              ),
            ),),
            const SizedBox(height: 25,),
            Container(
                height: 50,
                child: UI_simple_textfield(controller: mailController, labelText: "E-mail",)),
            const SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Visibility(
                  visible: errorMessage != '',
                  child: Text(errorMessage, style: const TextStyle(color: Colors.red),)
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: UI_gradient_button(title: "Envoyer", onPressed: () async {
                if (!mailController.text.contains(RegExp(r'[A-Z, a-z]'))){
                  setState(() {
                    errorMessage = "Merci d'entrer votre adresse email.";
                  });

                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      auth.sendPasswordResetEmail(email: mailController.text);
                      _timer = Timer(Duration(milliseconds: 1500), () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                        );
                      });
                      return _buildPopupDialog(context);
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildPopupDialog(BuildContext context) {
  return AlertDialog(
    backgroundColor: Colors.transparent,
    //title: const Text('Popup example'),
    content: Lottie.asset('assets/icons/email-send.json',
     repeat: false,
    ),
    elevation: 0,
  );
}
