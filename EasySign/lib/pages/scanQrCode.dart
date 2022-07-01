import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_sign/widgets/qrCode/qr_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScanQrCode extends StatefulWidget {
  final String idDocument;
  final String idIntervention;
  final String documentXml;
  final superviseur;
  const ScanQrCode({Key? key, required this.idDocument, required this.idIntervention, required this.documentXml, required this.superviseur}) : super(key: key);

  @override
  State<ScanQrCode> createState() => _ScanQrCodeState();
}

final firestoreInstance = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

class _ScanQrCodeState extends State<ScanQrCode> {
  var user;
  _getUserInfo() {
    firestoreInstance.collection('users').doc(auth.currentUser!.uid).get().then((usr) {
      setState(() {
        user = usr.data();
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
         'Scannez le qrCode',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: Container(
          child: QrScannerWidget(documentXml: widget.documentXml, idDocument: widget.idDocument, idIntervenant: user['uid'], idIntervention: widget.idIntervention, intervenantDeviceToken: user['deviceToken'], superviseur : widget.superviseur),
        ),
      ),
    );
  }
}
