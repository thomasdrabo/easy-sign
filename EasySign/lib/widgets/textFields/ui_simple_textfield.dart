import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UI_simple_textfield extends StatelessWidget {

  final bool? obscureText; // variable qui chosie si oui ou non on transforme le text en *
  final TextEditingController controller; // variable qui stock l'input du user
  final TextInputType? keyboardType; // variable qui choisie le type de clavier utilisé
  final String labelText; // variable qui contient le text affiché lorsque l'input est vide
  final Color? borderColor; // variable qui choisie la couleur de bordure par defaut
  final Color? focusBorderColor; // variable qui choisie la couleur de bordure par quand on saisie du text
  final int? maxLines; // variable qui choisie le nombre maximum de lignes
  final int? minLines; // variable qui choisie le nombre minimum de lignes

  const UI_simple_textfield({
    Key? key,
    this.obscureText,
    required this.controller,
    this.keyboardType,
    required this.labelText, 
    this.borderColor,
    this.focusBorderColor,
    this.maxLines,
    this.minLines
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines ?? 1,
      minLines: minLines ?? 1,

      controller: controller, // variable qui stock l'input du user
      obscureText: obscureText == null ? false : obscureText!, // variable qui chosie si oui on nous on transforme le text en *
      keyboardType: keyboardType == null ? TextInputType.text : keyboardType!,  // variable qui choisie le type de clavier utilisé
      decoration: InputDecoration(
        labelStyle: GoogleFonts.montserrat(
          textStyle: TextStyle(
            fontWeight: FontWeight.w400,
            color: Color(0xFF808080),
            fontSize: 15,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: borderColor == null ? const Color.fromRGBO(13, 66, 126, 0.2) : borderColor!,  // variable qui choisie la couleur de bordure par defaut
              width: 1.5
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: focusBorderColor == null ? const Color.fromRGBO(13, 66, 126, 0.5) : focusBorderColor!, // variable qui choisie la couleur de bordure par quand on saisie du text
              width: 2.5
          ),
        ),
        alignLabelWithHint: true,
        labelText: labelText,  // variable qui contient le text affiché lorsque l'input est vide
        floatingLabelStyle: GoogleFonts.montserrat(
        textStyle: TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.black,
          fontSize: 15,
        ),
      ),
      ),
    );
  }
}
