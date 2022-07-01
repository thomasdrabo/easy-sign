import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_sign/pages/scanQrCode.dart';
import 'package:easy_sign/widgets/buttons/ui_gradient_button.dart';
import 'package:easy_sign/widgets/qrCode/qr_code.dart';
import 'package:easy_sign/widgets/qrCode/qr_scanner.dart';
import 'package:easy_sign/widgets/xml/intervention_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xml/xml.dart';

class InfoInterventionIntervenant extends StatefulWidget {
  final String interventionId;
  const InfoInterventionIntervenant({Key? key, required this.interventionId}) : super(key: key);

  @override
  State<InfoInterventionIntervenant> createState() => _InfoInterventionIntervenantState();
}

final firestoreInstance = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

class _InfoInterventionIntervenantState extends State<InfoInterventionIntervenant> {
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
              var sign = null;
              var interventions = XmlDocument.parse(intervention['xmlFile']).getElement('document')!.getElement('interventions')!.childElements;
              for (var element in interventions) {
                
                sign = element.getElement('signature')?.innerText;
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
              return Visibility(
                visible: interventionsName[index][2] == auth.currentUser!.uid,
                child: Padding(
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
                                      InkWell(
                                        onTap: () async {
                                          var document = XmlDocument.parse(intervention['xmlFile']);
                                          for (var i in document.getElement('document')!.getElement('interventions')!.childElements) {
                                            if (i.getAttributeNode('id')!.value == index.toString()) {
                                              for (var j = 0; j < i.getElement('etapes')!.childElements.length; j++) {
                                                if (i.getElement('etapes')!.childElements.elementAt(j).getAttributeNode('id')!.value == index2.toString()) {
                                                  i.getElement('etapes')!.childElements.elementAt(j).getElement('etat')!.innerText = checked ? 'false' : 'true';
                                                  await firestoreInstance.collection('fichesInterventions').doc(widget.interventionId).update({'xmlFile': document.toXmlString()}).whenComplete(() {
                                                    _getIntervention();
                                                  });
                                                }
                                              }
                                            }
                                          }
                                          //print(XmlDocument.parse(intervention['xmlFile']).getElement('document')!.getElement('interventions')!.childElements);
                                        },
                                        child: Icon(
                                          checked ? Icons.check : Icons.pending_outlined,
                                          color: interventionsName[index][1][index2][1] == 'true' ? Colors.green : Colors.grey,
                                        ),
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
                                if (sign == '') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ScanQrCode(idDocument: XmlDocument.parse(intervention['xmlFile']).getElement('document')!.getElement('parametres')!.getElement('identifiant-du-document')!.innerText, idIntervention: index.toString(), documentXml: intervention['xmlFile'], superviseur: superviseur),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                  height: 30,
                                  width: MediaQuery.of(context).size.width / 1.7,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromRGBO(13, 66, 126, 0.2), // variable qui choisie la couleur de bordure par quand on saisie du text
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Center(child: Text(sign != '' ? "L'intervention est déja signée" : "Signer l'intervention"))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      )),
    );
  }
}
