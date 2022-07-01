import 'package:easy_sign/pages/home.dart';
import 'package:easy_sign/widgets/buttons/ui_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EndSignature extends StatefulWidget {
  final bool valid;
  const EndSignature({Key? key, required this.valid}) : super(key: key);

  @override
  State<EndSignature> createState() => _EndSignatureState();
}

class _EndSignatureState extends State<EndSignature> {
  @override
  Widget build(BuildContext context) {
    return widget.valid ? 
      Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        Image.asset('assets/icons/valid.png'),
        Text(
          "L'intervention a bien été signée.",
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
        UI_gradient_button(title: 'Accueil', onPressed: (){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
        })
      ]),
    )
    : 
     Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Echec',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Le superviseur ne correspond pas à celui renseigné dans le document.',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
