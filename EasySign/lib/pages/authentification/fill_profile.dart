import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:easy_sign/pages/home.dart';
import 'package:easy_sign/widgets/buttons/ui_gradient_button.dart';
import 'package:easy_sign/widgets/textFields/ui_simple_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class FillProfile extends StatefulWidget {
  final bool? googleOrApple;
  final String? googleImg;
  const FillProfile({Key? key, this.googleOrApple, this.googleImg}) : super(key: key);

  @override
  _FillProfileState createState() => _FillProfileState();
}

class _FillProfileState extends State<FillProfile> {
  //Controllers des textfields
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
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
      firestoreInstance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .update({'pdp': value});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    googlePic = widget.googleImg != null ? true : false;

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
                    controller: nameController,
                    labelText: "Votre Nom*",
                  )),
              const SizedBox(
                height: 15,
              ),
              Container(
                  height: 50,
                  child: UI_simple_textfield(
                    controller: surnameController,
                    labelText: "Votre prénom*",
                  )),
              Visibility(
                visible: widget.googleOrApple != null,
                child: const SizedBox(
                  height: 15,
                ),
              ),
              Visibility(
                visible: widget.googleOrApple != null,
                child: Container(
                    height: 50,
                    child: UI_simple_textfield(
                      controller: pseudoController,
                      labelText: "Votre pseudo*",
                    )),
              ),
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
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Votre date d'anniversaire : ",
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
                height: 10,
              ),
              DateTimePicker(
                decoration: InputDecoration(
                  labelStyle: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF808080),
                      fontSize: 15,
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(13, 66, 126,
                            0.2), // variable qui choisie la couleur de bordure par defaut
                        width: 1.5),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(13, 66, 126,
                            0.5), // variable qui choisie la couleur de bordure par quand on saisie du text
                        width: 2.5),
                  ),
                  prefixIcon: const Icon(Icons.calendar_month_outlined),
                  prefixIconColor: const Color.fromRGBO(13, 66, 126, 0.2),
                  iconColor: const Color.fromRGBO(13, 66, 126, 0.2),
                  focusColor: const Color.fromRGBO(13, 66, 126, 0.2),
                  labelText:
                      "Sélectionnez une date", // variable qui contient le text affiché lorsque l'input est vide
                  floatingLabelStyle: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
                initialValue: '',
                locale: const Locale("fr", "FR"),
                firstDate: DateTime.now().subtract(Duration(days: (365.2422*100).toInt())),
                lastDate: DateTime.now(),
                dateLabelText: 'Date',
                onChanged: (val) => birthday = val,
                validator: (val) {
                  print(val);
                  return null;
                },
                onSaved: (val) => birthday = val,
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
                borderRadius:
                    const BorderRadius.all(Radius.circular(100.0)),
                onTap: () async {
                  XFile image = (await ImagePicker.platform.getImage(
                      source: ImageSource.gallery, imageQuality: 100)) as XFile;
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
                    child: googlePic ?
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(100))),
                      height: 100,
                      width: 100,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(100)),
                        child: Image.network(
                            widget.googleImg!,
                            fit: BoxFit.cover),
                      ),
                    ) :
                    !pic
                        ? SvgPicture.asset("assets/icons/plus.svg")
                        : Container(
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(100))),
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(100)),
                              child: Image.file(
                                  add_photo,
                                  fit: BoxFit.cover),
                            ),
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Visibility(
                    visible: errorMessage != '',
                    child: Text(errorMessage, style: const TextStyle(color: Colors.red),)
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: UI_gradient_button(
                    title: "Terminer",
                    onPressed: () {
                      if(!nameController.text.contains(new RegExp(r'[A-Z, a-z]'))){
                        setState(() {
                          errorMessage = "Merci d'entrer votre nom.";
                        });
                      }
                       else if(!surnameController.text.contains(new RegExp(r'[A-Z, a-z]'))){
                        setState(() {
                          errorMessage = "Merci d'entrer votre prénom.";
                        });
                      }
                      else {
                        if (pic){
                          uploadImageToFirebase(add_photo, 'users/' + auth.currentUser!.uid + '/pdp',);
                        }
                        if(widget.googleOrApple != null){
                          if(pseudoController.text.isEmpty){
                            setState(() {
                              errorMessage = "Merci d'entrer votre pseudo.";
                            });
                          } else {
                            if (pseudoController.text.contains(' ')){
                              setState(() {
                                errorMessage = "Assurez-vous que votre pseudo ne contient pas d'espace.";
                              });
                            } else {
                              List searchKeywords = [];
                              for(int i = 0; i < pseudoController.text.length; i++) {
                                if(searchKeywords.isEmpty) {
                                  searchKeywords.add(pseudoController.text[i].toLowerCase());
                                } else {
                                  searchKeywords.add(searchKeywords[searchKeywords.length - 1] + pseudoController.text[i].toLowerCase());
                                }
                              }
                              firestoreInstance.collection('users').doc(auth.currentUser!.uid).update({
                                'firstName' : surnameController.text,
                                'lastName' : nameController.text,
                                'city' : cityController.text,
                                'birthday' : birthday,
                                'pseudo' : pseudoController.text,
                                "searchKeywords" : searchKeywords,
                              });
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (context) => const Home()));
                            }
                          }
                        } else {
                          firestoreInstance.collection('users').doc(auth.currentUser!.uid).update({
                            'firstName' : surnameController.text,
                            'lastName' : nameController.text,
                            'city' : cityController.text,
                            'birthday' : birthday
                          });
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (context) => const Home()));
                        }
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
