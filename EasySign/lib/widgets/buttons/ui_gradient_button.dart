import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UI_gradient_button extends StatelessWidget {

  final String title;
  final Function() onPressed;
  const UI_gradient_button({
    Key? key,
    required this.title,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
            textStyle: const TextStyle(fontSize: 20),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          shadowColor: Colors.transparent
        ),
        onPressed: onPressed,
        child: Ink(
          padding: EdgeInsets.zero,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[Color.fromRGBO(173, 139, 115, 1), Color.fromRGBO(227, 202, 165, 1)],
            ),
            borderRadius: BorderRadius.all(Radius.circular(80.0)),
          ),
          child: Container(
            constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
            alignment: Alignment.center,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
