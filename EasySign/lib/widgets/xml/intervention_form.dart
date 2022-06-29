import 'package:easy_sign/pages/page4.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../buttons/ui_rounded_icon_button.dart';
import '../textFields/ui_simple_textfield.dart';

class InterventionForm extends StatefulWidget {
  const InterventionForm({Key? key}) : super(key: key);

  @override
  InterventionFormState createState() => InterventionFormState();
  
}


class InterventionFormState extends State<InterventionForm> {

  final _formKey = GlobalKey<FormState>();

  //Controllers des textfields
  final interventionNameController = TextEditingController();
  final interventionsController = TextEditingController();
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
              Text("Nouvelle fiche d'intervention", style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),),
            ],
          ),
          const SizedBox(height: 15),
          Container(
              height: 50,
              child: UI_simple_textfield(
                focusBorderColor: Colors.white,
                controller: interventionNameController, 
                labelText: "Nom de l'intervention",
                labelTextColor: Colors.white)),
          const SizedBox(height: 15),
          Text("INTERVENTIONS", style: TextStyle(color: Colors.white, fontSize: 20)),
          Container(
            margin: EdgeInsets.all(25),
            child: MyWidget(
          )),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Visibility(
              visible: errorMessage != '',
                child: Text(errorMessage, style: const TextStyle(color: Colors.red),)
            )
          )
        ]
      )
    );  
  }
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool showWidget = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        showWidget
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NewIntervention()
                ],
              )
            : Container(),
        TextButton(
          onPressed: () {
            setState(() {
              showWidget = !showWidget;
            });
          },
          child: UI_rounded_icon_button(
            title: "Ajouter",
            icon: "assets/icons/plus.svg",
                      onPressed: () {
            setState(() {
              showWidget = !showWidget;
            });
          },
          ),
        ),
      ],
    );
  }
}

Widget NewIntervention(){
    final interventionNameController = TextEditingController();
    final intervenantController = TextEditingController();
    final posteController = TextEditingController();
    final etapeController = TextEditingController();
      String errorMessage = '';
   return Column(

        //physics: BouncingScrollPhysics(),
        children: [
          Row(
            children: [
              Text("Nouvelle intervention", style: GoogleFonts.montserrat(

                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
              height: 50,
              child: UI_simple_textfield(
                focusBorderColor: Colors.white,
                controller: interventionNameController, 
                labelText: "Nom de l'intervention",
                labelTextColor: Colors.white)),
          const SizedBox(height: 15),
          Container(
              height: 50,
              child: UI_simple_textfield(
                focusBorderColor: Colors.white,
                controller: intervenantController, 
                labelText: "Intervenant",
                labelTextColor: Colors.white
                )
            ),
          const SizedBox(height: 15),
          Container(
              height: 50,
              child: UI_simple_textfield(
                focusBorderColor: Colors.white,
                controller: posteController, 
                labelText: "Poste",
                labelTextColor: Colors.white
                )
            ),
          const SizedBox(height: 15),
          Container(
              height: 50),     
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Visibility(
              visible: errorMessage != '',
                child: Text(errorMessage, style: const TextStyle(color: Colors.red),)
            )
          )
        ]
    ); 
    // var intervention = Intervention(interventionNameController.text, intervenantController.text, posteController.text, etapeController.text) ;
}


Widget NewEtape(){
    final etapeController = TextEditingController();
    var etape = Etape(etapeController.text);
   return Column(
        children: [
          Row(
            children: [
              Text("Nouvelle etape", style: GoogleFonts.montserrat(

                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
              height: 50,
              child: UI_simple_textfield(
                focusBorderColor: Colors.white,
                controller: etapeController, 
                labelText: "Nom de l'étape",
                labelTextColor: Colors.white)),
        ]
    );

}

