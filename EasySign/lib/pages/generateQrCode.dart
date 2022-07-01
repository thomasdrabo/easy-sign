import 'package:easy_sign/pages/home.dart';
import 'package:easy_sign/widgets/buttons/ui_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/qrCode/qr_code.dart';

class GenerateQrCode extends StatefulWidget {
  final String superviseurId;
  final String superviserDeviceToken;
  final String idIntervention;
  const GenerateQrCode({Key? key, required this.superviseurId, required this.superviserDeviceToken, required this.idIntervention}) : super(key: key);

  @override
  State<GenerateQrCode> createState() => _GenerateQrCodeState();
}

class _GenerateQrCodeState extends State<GenerateQrCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        title: Text(
          'QR Code de signature',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Spacer(),
            Center(
              child: Container(
                child: QrCodeWidget(data: widget.superviseurId + ',' + widget.idIntervention + ',' + widget.superviserDeviceToken),
              ),
            ),
             Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: UI_gradient_button(
                  title: 'Accueil',
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
                  }),
            ),
            Spacer(),
           Container(),
          ],
        ),
      ),
    );
  }
}
