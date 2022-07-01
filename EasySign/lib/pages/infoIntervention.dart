import 'package:easy_sign/pages/generateQrCode.dart';
import 'package:easy_sign/widgets/buttons/ui_gradient_button.dart';
import 'package:easy_sign/widgets/xml/intervention_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xml/xml.dart';

class InfoIntervention extends StatefulWidget {
  final String interventionId;
  const InfoIntervention({Key? key, required this.interventionId}) : super(key: key);

  @override
  State<InfoIntervention> createState() => _InfoInterventionState();
}

class _InfoInterventionState extends State<InfoIntervention> {
  Map intervention = {};
  _getIntervention() {
    firestoreInstance.collection('fichesInterventions').doc(widget.interventionId).get().then((inter) {
      setState(() {
        intervention = inter.data() as Map;
      });
    }).whenComplete(() {
      _getSuperviseurInfo();
    });
  }

  var superviseur;
  _getSuperviseurInfo() {
    var doc = XmlDocument.parse(intervention['xmlFile']);
    firestoreInstance.collection('users').doc(doc.getElement('document')!.getElement('parametres')!.getElement('identifiant-du-superviseur')!.innerText).get().then((superV) {
      setState(() {
        superviseur = superV.data();
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getIntervention();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          XmlDocument.parse(intervention['xmlFile']).getElement('document')!.getElement('parametres')!.getElement('nom-intervention')!.innerText,
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
            itemCount: int.parse(XmlDocument.parse(intervention['xmlFile']).getElement('document')!.getElement('parametres')!.getElement('nombre-intervention')!.innerText),
            itemBuilder: (BuildContext ctxt, int index) {
              List interventionsName = [];
              List etapeState = [];
              var interventions = XmlDocument.parse(intervention['xmlFile']).getElement('document')!.getElement('interventions')!.childElements;
              for (var element in interventions) {
                var etapes = element.getElement('etapes')!.childElements;
                List etapesInfo = [];
                List etapesState = [];
                for (var i = 0; i < etapes.length; i++) {
                  etapesInfo.add([etapes.elementAt(i).getElement('nom')!.innerText, etapes.elementAt(i).getElement('etat')!.innerText]);
                  etapesState.add(etapes.elementAt(i).getElement('etat')!.innerText);
                }
                interventionsName.add([element.getElement('nom')!.innerText, etapesInfo, element.getElement('id-intervenant')!.innerText]);
                etapeState.add(etapesState);
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
                        child: Text(
                          interventionsName[index][0],
                          style: TextStyle(decoration: TextDecoration.underline),
                        ),
                      ),
                      Container(
                        height: (40 * interventionsName[index][1].length).toDouble(),
                        child: ListView.builder(
                            itemCount: interventionsName[index][1].length,
                            itemBuilder: (BuildContext ctxt, int index2) {
                              List<bool> showButton = [];
                              bool checked = interventionsName[index][1][index2][1] == 'true';

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text('- ' + interventionsName[index][1][index2][0]),
                                    Spacer(),
                                    Icon(
                                      checked ? Icons.check : Icons.pending_outlined,
                                      color: interventionsName[index][1][index2][1] == 'true' ? Colors.green : Colors.grey,
                                    )
                                  ],
                                ),
                              );
                            }),
                      ),
                      Visibility(
                        visible: !etapeState[index].contains('false'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GenerateQrCode(superviseurId: superviseur['uid'], superviserDeviceToken: superviseur['deviceToken'], idIntervention: index.toString()),
                                ),
                              );
                            },
                            child: Container(
                                height: 30,
                                width: MediaQuery.of(context).size.width / 1.5,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromRGBO(13, 66, 126, 0.2), // variable qui choisie la couleur de bordure par quand on saisie du text
                                      width: 1.5),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Center(child: Text("Générer le QR Code de signature"))),
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
