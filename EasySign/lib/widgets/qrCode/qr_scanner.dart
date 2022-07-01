import 'dart:developer';
import 'dart:io';

import 'package:easy_sign/pages/endSignature.dart';
import 'package:easy_sign/pages/infoInterventionIntervenant.dart';
import 'package:easy_sign/services/sign/document_sign.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:xml/xml.dart';

class QrScannerWidget extends StatefulWidget {
  final String idDocument;
  final String idIntervention;
  final String idIntervenant;
  final String intervenantDeviceToken;
  final String documentXml;
  final superviseur;
  const QrScannerWidget({Key? key, required this.idDocument, required this.idIntervention, required this.idIntervenant, required this.intervenantDeviceToken, required this.documentXml, required this.superviseur}) : super(key: key);

  @override
  State<QrScannerWidget> createState() => _QrScannerWidgetState();
}

class _QrScannerWidgetState extends State<QrScannerWidget> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  var finalDocXml = '';
  @override
  void initState() {
    setState(() {
      finalDocXml = widget.documentXml;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null) Text('Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}') else const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text('Flash: ${snapshot.data}');
                              },
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text('Camera facing ${describeEnum(snapshot.data!)}');
                                } else {
                                  return const Text('loading');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child: const Text('pause', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: const Text('Scan QRCode', style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 150.0 : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(borderColor: Colors.red, borderRadius: 10, borderLength: 30, borderWidth: 10, cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      result = scanData;
      var idSuperviseur = result!.code!.split(',').first;
      var idInter = result!.code!.split(',').elementAt(1);
      var superviseurDeviceToken = result!.code!.split(',').last;

      if (widget.superviseur['uid'] == idSuperviseur && widget.superviseur['deviceToken'] == superviseurDeviceToken && widget.idIntervention == idInter) {
        var sign = encryptSygnature([widget.idDocument, widget.idIntervention, idSuperviseur, superviseurDeviceToken, widget.idIntervenant, widget.intervenantDeviceToken]);
        var doc = XmlDocument.parse(finalDocXml);
        doc.getElement('document')!.getElement('interventions')!.childElements.elementAt(int.parse(widget.idIntervention)).getElement('signature')!.innerText = sign;
        firestoreInstance.collection('fichesInterventions').doc(widget.idDocument).update({
          'xmlFile': doc.toXmlString(),
        });
        firestoreInstance.collection('fichesInterventions').doc(widget.idDocument).collection('signatures').doc().set({'date': DateTime.now(), 'idIntervenant': widget.idIntervenant, 'idSignature': sign});
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const EndSignature(
                  valid: true,
                )));
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EndSignature(valid: false),
          ),
        );
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
