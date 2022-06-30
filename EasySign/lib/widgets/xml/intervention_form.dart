import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_sign/pages/page4.dart';
import 'package:easy_sign/widgets/buttons/ui_gradient_button.dart';
import 'package:easy_sign/widgets/xml/intervenantsList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:xml/xml.dart';

import '../buttons/ui_rounded_icon_button.dart';
import '../textFields/ui_simple_textfield.dart';

class InterventionForm extends StatefulWidget {
  const InterventionForm({Key? key}) : super(key: key);

  @override
  InterventionFormState createState() => InterventionFormState();
}

final FirebaseAuth auth = FirebaseAuth.instance;
final firestoreInstance = FirebaseFirestore.instance;

class Etape {
  final String name;
  final bool etat;

  const Etape(this.name, [this.etat = false]);
}

class Intervention {
  final String name;
  final String intervenant;
  final String poste;
  final String id;
  final List<Etape> etapes;

  const Intervention(
    this.name,
    this.intervenant,
    this.poste,
    this.id,
    this.etapes,
  );
}

List<Etape> etapes = [];
List<Intervention> interventions = [];
List idIntervenants = [];

_sendIntervention(interventionName, intervenantName, post, id) {
  print(interventionName);
  interventions.add(Intervention(interventionName, intervenantName, post, id, etapes));
  idIntervenants.add(id);
  etapes = [];
}

class InterventionFormState extends State<InterventionForm> {
  final _formKey = GlobalKey<FormState>();

  //Controllers des textfields
  final globalInterventionNameController = TextEditingController();
  final interventionsController = TextEditingController();
  final passwordController = TextEditingController();
  final verifPasswordController = TextEditingController();

  String errorMessage = '';
  String errorMessage0 = '';
  String errorMessage2 = '';

  final interventionNameController = TextEditingController();
  Map intervenant = {
    'name': '',
  };
  final posteController = TextEditingController();
  final etapeController = TextEditingController();
  int etapeNumber = 1;
  int interventionNumber = 1;
  bool showWidget = false;

  _updateIntervenant(intervenantDoc) {
    setState(() {
      intervenant = intervenantDoc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Nouvelle fiche d'intervention",
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Visibility(
                    visible: errorMessage0 != '',
                    child: Text(
                      errorMessage0,
                      style: const TextStyle(color: Colors.red),
                    ))),
            const SizedBox(height: 15),
            Container(height: 50, child: UI_simple_textfield(focusBorderColor: Colors.white, controller: globalInterventionNameController, labelText: "Nom de l'intervention", labelTextColor: Colors.white)),
            const SizedBox(height: 15),
            Text("INTERVENTIONS", style: TextStyle(color: Colors.white, fontSize: 20)),
            Container(
                margin: EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    showWidget
                        ? Column(

                            //physics: BouncingScrollPhysics(),
                            children: [
                                Row(
                                  children: [
                                    Text(
                                      "Intervention numéro " + interventionNumber.toString() + ' :',
                                      style: GoogleFonts.montserrat(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Container(height: 50, child: UI_simple_textfield(focusBorderColor: Colors.white, controller: interventionNameController, labelText: "Nom de l'intervention", labelTextColor: Colors.white)),
                                const SizedBox(height: 15),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => IntervenantsList(updateIntervenant: _updateIntervenant),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    intervenant['name'] == '' ? 'Choisissez un intervenant' : intervenant['name'],
                                    style: TextStyle(decoration: TextDecoration.underline),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Container(height: 50, child: UI_simple_textfield(focusBorderColor: Colors.white, controller: posteController, labelText: "Poste", labelTextColor: Colors.white)),
                                const SizedBox(height: 15),
                                Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: Visibility(
                                        visible: errorMessage != '',
                                        child: Text(
                                          errorMessage,
                                          style: const TextStyle(color: Colors.red),
                                        ))),
                                Text('Etape numéro ' + etapeNumber.toString() + ' :'),
                                const SizedBox(height: 15),
                                Container(height: 50, child: UI_simple_textfield(focusBorderColor: Colors.white, controller: etapeController, labelText: "Nom de l'étape", labelTextColor: Colors.white)),
                                Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: Visibility(
                                        visible: errorMessage2 != '',
                                        child: Text(
                                          errorMessage2,
                                          style: const TextStyle(color: Colors.red),
                                        ))),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: UI_gradient_button(
                                    onPressed: () {
                                      setState(() {
                                        if (!etapeController.text.contains(new RegExp(r'[A-Z, a-z]'))) {
                                          errorMessage2 = "Merci d'entrer un nom à l'étape.";
                                        } else {
                                          errorMessage2 = "";
                                          etapes.add(Etape(etapeController.text));
                                          etapeController.clear();
                                          etapeNumber++;
                                        }
                                      });
                                    },
                                    title: "Valider l'étape",
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: UI_gradient_button(
                                    onPressed: () {
                                      setState(() {
                                        if (!interventionNameController.text.contains(new RegExp(r'[A-Z, a-z]')) || intervenant['name'] == '' || !posteController.text.contains(new RegExp(r'[A-Z, a-z]'))) {
                                          errorMessage = "Merci de remplir tous les champs.";
                                        } else {
                                          errorMessage = "";
                                          if (etapes.length >= 1) {
                                            _sendIntervention(interventionNameController.text, intervenant['name'], posteController.text, intervenant['uid']);
                                            interventionNameController.clear();
                                            intervenant = {'name': ''};
                                            posteController.clear();
                                            etapeNumber = 1;
                                            etapeController.clear();
                                            interventionNumber++;
                                          } else {
                                            errorMessage2 = "Merci de rentrer au moins une étape.";
                                          }
                                        }
                                      });
                                    },
                                    title: "Valider l'intervention",
                                  ),
                                )
                              ])
                        : Container(),
                    UI_rounded_icon_button(
                      fontSize: 13,
                      title: showWidget ? "Générer la fiche d'intervention" : "Ajouter",
                      icon: "assets/icons/plus.svg",
                      onPressed: () {
                        setState(() {
                          if (!showWidget) {
                            showWidget = true;
                          } else {
                            if (!globalInterventionNameController.text.contains(new RegExp(r'[A-Z, a-z]'))) {
                              errorMessage0 = "Merci d'entrer un nom à votre fiche d'intervention.";
                            } else {
                              createXML(auth.currentUser!.uid, globalInterventionNameController.text, interventions);
                            }
                          }
                        });
                      },
                    ),
                  ],
                )),
          ])),
    );
  }

  void createXML(String idSuperviseur, String interventionName, List<Intervention> interventions) {
    List<String> intervenants = [];
    String idDoc = const Uuid().v1();
    var date = DateTime.now();
    for (var element in interventions) {
      intervenants.add(element.intervenant);
    }
    var intervenantCount = intervenants.toSet().toList().length;
    final builder = XmlBuilder();
    builder.xml('<?xml version="1.0" encoding="utf-8"?>');
    builder.xml('<?xml-stylesheet href="certif.xsl" type="text/xsl"?>');
    builder.element("document", isSelfClosing: false, nest: () {
      builder.element("parametres", isSelfClosing: false, nest: () {
        builder.element("identifiant-du-document", isSelfClosing: false, nest: () {
          builder.text(idDoc);
        });
        builder.element("identifiant-du-superviseur", isSelfClosing: false, nest: () {
          builder.text(idSuperviseur);
        });
        builder.element("nom-intervention", isSelfClosing: false, nest: () {
          builder.text(interventionName);
        });
        builder.element("horodatage", isSelfClosing: false, nest: () {
          builder.text(date);
        });
        builder.element("nombre-intervention", isSelfClosing: false, nest: () {
          builder.text(interventions.length);
        });
        builder.element("nombre-intervenant", isSelfClosing: false, nest: () {
          builder.text(intervenantCount);
        });
      });

      builder.element("interventions", isSelfClosing: false, nest: () {
        var i = 0;
        for (var x in interventions) {
          builder.element("intervention", isSelfClosing: false, nest: () {
            builder.attribute("id", i);
            builder.element("nom", isSelfClosing: false, nest: () {
              builder.text(x.name);
            });
            builder.element("nom-intervenant", isSelfClosing: false, nest: () {
              builder.text(x.intervenant);
            });
            builder.element("id-intervenant", isSelfClosing: false, nest: () {
              builder.text(x.id);
            });
            builder.element("poste", isSelfClosing: false, nest: () {
              builder.text(x.poste);
            });
            var j = 0;
            for (var y in x.etapes) {
              builder.element("etape", isSelfClosing: false, nest: () {
                builder.attribute("id", j);
                builder.element("nom", isSelfClosing: false, nest: () {
                  builder.text(y.name);
                });
                builder.element("etat", isSelfClosing: false, nest: () {
                  builder.text(y.etat);
                });
              });
              j++;
            }
            builder.element("signature", isSelfClosing: false);
          });

          i++;
        }
      });
    });
    final doc = builder.buildDocument();
    firestoreInstance.collection('fichesInterventions').doc(idDoc).set({'superviseurId': auth.currentUser!.uid, 'intervenantsId': idIntervenants, 'date': date, 'xmlFile': doc.toXmlString(), 'signatures': []}).whenComplete(() {
      showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog(context),
      );
    }).onError((error, stackTrace) => print(error));
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Création terminé'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Fiche d'intervention créée avec succès."),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Terminer'),
        ),
      ],
    );
  }
}
