import 'package:easy_sign/widgets/buttons/ui_gradient_button.dart';
import 'package:easy_sign/widgets/xml/intervention_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xml/xml.dart';

class InfoIntervention extends StatefulWidget {
  final Map intervention;
  const InfoIntervention({Key? key, required this.intervention}) : super(key: key);

  @override
  State<InfoIntervention> createState() => _InfoInterventionState();
}

class _InfoInterventionState extends State<InfoIntervention> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          XmlDocument.parse(widget.intervention['xmlFile']).getElement('document')!.getElement('parametres')!.getElement('nom-intervention')!.innerText,
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: SafeArea(
          child: Container(
        height: double.infinity,
        child: ListView.builder(
            itemCount: int.parse(XmlDocument.parse(widget.intervention['xmlFile']).getElement('document')!.getElement('parametres')!.getElement('nombre-intervention')!.innerText),
            itemBuilder: (BuildContext ctxt, int index) {
              List interventionsName = [];
              var interventions = XmlDocument.parse(widget.intervention['xmlFile']).getElement('document')!.getElement('interventions')!.childElements;
              for (var element in interventions) {
                var etapes = element.getElement('etapes')!.childElements;
                List etapesInfo = [];
                for (var i = 0; i < etapes.length - 1; i++) {
                  etapesInfo.add([etapes.elementAt(i).getElement('nom')!.innerText, etapes.elementAt(i).getElement('etat')!.innerText]);
                }
                interventionsName.add([element.getElement('nom')!.innerText, etapesInfo]);
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromRGBO(13, 66, 126, 0.2), // variable qui choisie la couleur de bordure par quand on saisie du text
                        width: 1.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(interventionsName[index][0], style: TextStyle(
                          decoration: TextDecoration.underline
                        ),),
                      ),
                      Container(
                        height: (40 * interventionsName[index][1].length).toDouble(),
                        child: ListView.builder(
                            itemCount: interventionsName[index][1].length,
                            itemBuilder: (BuildContext ctxt, int index2) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text('- ' + interventionsName[index][1][index2][0]),
                                    Spacer(),
                                    Icon(interventionsName[index][1][index2][1] == 'true' ?  Icons.check : Icons.pending_outlined, color: interventionsName[index][1][index2][1] == 'true' ? Colors.green : Colors.grey,)
                                  ],
                                ),
                              );
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: InkWell(
                          onTap: (){
                            
                          },
                          child: Container(
                             height: 30,
                              width: MediaQuery.of(context).size.width/2,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color.fromRGBO(13, 66, 126, 0.2), // variable qui choisie la couleur de bordure par quand on saisie du text
                                    width: 1.5),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            child: Center(child: Text("Signer l'intervention"))
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              );
            }),
      )),
    );
  }
}
