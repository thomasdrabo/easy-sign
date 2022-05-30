import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class UI_rounded_icon_button extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final String icon;
  const UI_rounded_icon_button(
      {Key? key, required this.title, required this.onPressed, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: Colors.grey,
            textStyle: const TextStyle(fontSize: 20),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80.0),
              side: const BorderSide(color: Colors.black, width: 2),
            ),
            shadowColor: Colors.transparent
        ),
        child: Stack(
          children: [
             Align(
              alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Container(
                    width: 20,
                      child: SvgPicture.asset(icon)),
                ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                title,
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
