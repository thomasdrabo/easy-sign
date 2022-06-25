import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:easy_sign/pages/home.dart';
import 'package:easy_sign/widgets/buttons/ui_gradient_button.dart';
import 'package:easy_sign/widgets/textFields/ui_simple_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class FillProfileSociete extends StatefulWidget {
  const FillProfileSociete({Key? key}) : super(key: key);

  @override
  _FillProfileSocieteState createState() => _FillProfileSocieteState();
}

class _FillProfileSocieteState extends State<FillProfileSociete> {
  //Controllers des textfields
  final sirenController = TextEditingController();
  final cityController = TextEditingController();
  final pseudoController = TextEditingController();

  //Instance firebase
  final firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String errorMessage = '';

  //Variables utilisées pour être envoyé en base
  File add_photo = File('');

  bool pic = false;
  bool googlePic = false;
  var birthday;

  //Fonction pour upload les images dans firebase storage
  Future uploadImageToFirebase(File img, String url) async {
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(url);
    UploadTask uploadTask = firebaseStorageRef.putFile(img);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    taskSnapshot.ref.getDownloadURL().then((value) {
      firestoreInstance.collection('users').doc(auth.currentUser!.uid).update({'pdp': value});
    });
  }

  PlatformFile? pickedFile;
  Future _selectFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future _uploadFile() async {
    final path = 'users/' + auth.currentUser!.uid + '/extraitKbis';
    final file = File(pickedFile!.path!);

    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask = firebaseStorageRef.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    taskSnapshot.ref.getDownloadURL().then((value) {
      firestoreInstance.collection('users').doc(auth.currentUser!.uid).update({'kbis': value});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Compléter votre profil",
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
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Information du profil : ",
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                  height: 50,
                  child: UI_simple_textfield(
                    controller: sirenController,
                    labelText: "Votre numéro SIREN*",
                  )),
              const SizedBox(
                height: 15,
              ),
              Container(
                  height: 50,
                  child: UI_simple_textfield(
                    controller: cityController,
                    labelText: "Votre ville principale*",
                  )),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: _selectFile,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromRGBO(13, 66, 126, 0.2), // variable qui choisie la couleur de bordure par quand on saisie du text
                        width: 1.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        pickedFile == null ? 'Selectionnez votre extrait kbis' : pickedFile!.name,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: pickedFile == null ? Color(0xFF808080) : Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Photo de profil :",
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(100.0)),
                onTap: () async {
                  XFile image = (await ImagePicker.platform.getImage(source: ImageSource.gallery, imageQuality: 100)) as XFile;
                  var result = await FlutterImageCompress.compressAndGetFile(
                    image.path,
                    image.path.substring(0, image.path.length - 4) + 'tmp.jpeg',
                    quality: 15,
                  );
                  setState(() {
                    add_photo = result!;
                    googlePic = false;
                    pic = true;
                  });
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE2E9F0),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: !pic
                        ? SvgPicture.asset("assets/icons/plus.svg")
                        : Container(
                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100))),
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(100)),
                              child: Image.file(add_photo, fit: BoxFit.cover),
                            ),
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Visibility(
                    visible: errorMessage != '',
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: UI_gradient_button(
                    title: "Terminer",
                    onPressed: () {
                      if (!sirenController.text.contains(new RegExp(r'[A-Z, a-z, 0-9]'))) {
                        setState(() {
                          errorMessage = "Merci d'entrer votre numéro Siren.";
                        });
                      } else if (pickedFile == null) {
                        setState(() {
                          errorMessage = "Merci de séléctionner votre extrait kbis.";
                        });
                      } else {
                        if (pic) {
                          uploadImageToFirebase(
                            add_photo,
                            'users/' + auth.currentUser!.uid + '/pdp',
                          );
                        }
                        _uploadFile();
                        firestoreInstance.collection('users').doc(auth.currentUser!.uid).update({
                          'siren': sirenController.text,
                          'city': cityController.text,
                        });
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
