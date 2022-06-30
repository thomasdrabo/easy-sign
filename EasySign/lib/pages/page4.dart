import 'dart:io';
import 'package:easy_sign/widgets/xml/intervention_form.dart';
import 'package:xml/xml.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';


import 'package:flutter/material.dart';


class Etape {
  final String name;
  final bool etat;
  
  const Etape(this.name, [this.etat = false]);
}

class Intervention {
  final String name;
  final String intervenant;
  final String poste;
  final List<Etape> etapes;
  
  const Intervention(this.name, this.intervenant, this.poste, this.etapes);
}
class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);


  @override

  Widget build(BuildContext context) {
    List<Etape> etapes = [const Etape("name", true), const Etape("name1", false)];
    Intervention test1 = Intervention("name", "intervenant", "poste", etapes);
    Intervention test2 = Intervention("name2", "intervenant2", "poste2", etapes);
    Intervention test3 = Intervention("name3", "intervenant3", "poste3", etapes);
    List<Intervention> test = [test1, test2, test3];
      return Scaffold(
        backgroundColor: Colors.orange,
        body: SafeArea(
          child: Container(
            child: ElevatedButton(
              child: Text('test'),
              onPressed: () => createXML("tt", "sdfsd", test),
            ),
          ),
        ),
      );
  }

  Widget toto() {
  
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: Container(
          child: InterventionForm(),
          ),
        ),
      );
  }




  String createXML (
    String idSuperviseur, 
    String interventionName, 
    List<Intervention> interventions ) {

    List<String> intervenants = [];
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
          builder.text(const Uuid().v1());
        });
        builder.element("identifiant-du-superviseur", isSelfClosing: false, nest: () {
          builder.text(idSuperviseur);
        });        
        builder.element("nom-intervention", isSelfClosing: false, nest: () {
          builder.text(interventionName);
        });
        builder.element("horodatage", isSelfClosing: false, nest: () {
          builder.text(DateTime.now());
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
      for (var x in interventions){

          builder.element("intervention", isSelfClosing: false, nest: () {
            builder.attribute("id", i);
            builder.element("nom", isSelfClosing: false, nest: () {
              builder.text(x.name);
            });
            builder.element("intervenant", isSelfClosing: false, nest: () {
              builder.text(x.intervenant);
            });
            builder.element("poste", isSelfClosing: false, nest: () {
              builder.text(x.poste);
            });
            var j = 0;
            for (var y in x.etapes){
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

      }
      

    );
      final doc = builder.buildDocument();
      print(doc.toString());
      return doc.toXmlString();
  }
}