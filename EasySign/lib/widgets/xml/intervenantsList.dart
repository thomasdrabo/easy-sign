import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntervenantsList extends StatefulWidget {
  final Function updateIntervenant;
  const IntervenantsList({Key? key, required this.updateIntervenant}) : super(key: key);

  @override
  State<IntervenantsList> createState() => _IntervenantsListState();
}

class _IntervenantsListState extends State<IntervenantsList> {
  final firestoreInstance = FirebaseFirestore.instance;

  List intervenantsList = [];
  _getIntervenants() {
    firestoreInstance.collection('users').where('accountType', arrayContains: 'intervenant').get().then((intervenants) {
      for (var intervenant in intervenants.docs) {
        firestoreInstance.collection('users').doc(intervenant.data()['entreprise']).get().then((entreprise) {
          setState(() {
            intervenantsList.add([intervenant.data(), entreprise.data()]);
          });
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getIntervenants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Liste des intervenants",
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.builder(
              itemCount: intervenantsList.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return InkWell(
                  onTap: () {
                    widget.updateIntervenant(intervenantsList[index][0]);
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40.0),
                            image: DecorationImage(image: NetworkImage(intervenantsList[index][0]['pdp']), fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2.0),
                            child: Text(intervenantsList[index][0]['name']),
                          ),
                          Text(
                            intervenantsList[index][1]['name'],
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
