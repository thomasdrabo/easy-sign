import 'package:easy_sign/services/flutter_switch/flutter_switch.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UI_switch_bar extends StatefulWidget {

  final String title_left;
  final String title_right;
  final Color? background_color;
  final Color? button_color;
  final Function onclick_left;
  final Function onclick_right;

  const UI_switch_bar({Key? key, required this.title_left, required this.title_right, this.background_color, this.button_color, required this.onclick_left, required this.onclick_right}) : super(key: key);

  @override
  State<UI_switch_bar> createState() => _UI_switch_barState();
}

class _UI_switch_barState extends State<UI_switch_bar> {

  bool status = false;

  @override
  Widget build(BuildContext context) {

    return FlutterSwitch(
      toggleBorder: Border.all(
        width: 0, color: widget.background_color == null ? Color(0xFFE8F3FF) : widget.background_color!,
      ),
      activeColor: widget.background_color == null ? Color(0xFFE8F3FF) : widget.background_color!,
      inactiveColor: widget.background_color == null ? Color(0xFFE8F3FF) : widget.background_color!,
      toggleColor: widget.button_color == null ? Colors.white : widget.button_color!,
      switchBorder: Border.all(
        width: 5, color: widget.background_color == null ? Color(0xFFE8F3FF) : widget.background_color!,
      ),
      width: 340.0,
      height: 55.0,
      valueFontSize: 20.0,
      toggleSize: 42.0,
      inactiveIcon: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(widget.title_left, style: GoogleFonts.montserrat(
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontSize: 10,
          ),
        ),),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(widget.title_right, style: GoogleFonts.montserrat(
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontSize: 10,
          ),
        ),),
      ),
      value: status,
      borderRadius: 30.0,
      padding: 0,
      activeText: widget.title_left,
      inactiveText: widget.title_right,
      showOnOff: true,
      onToggle: (val) {
        setState(() {
          status = val;
          if (status == true) {
            widget.onclick_right();
          }
          if (status == false) {
            widget.onclick_left();
          }
        });
      }, toggleSizeHeight: 60, toggleSizeWidth: 170,
    );
  }
}
