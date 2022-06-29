import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:easy_sign/widgets/buttons/ui_gradient_button.dart';
import 'package:file_picker/file_picker.dart';

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

final FirebaseAuth auth = FirebaseAuth.instance;
final firestoreInstance = FirebaseFirestore.instance;
class _Page2State extends State<Page2> {
  PlatformFile? pickedFile;

  Future _selectFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xml']);
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future _uploadFile() async {
    final path = 'users/' + auth.currentUser!.uid + '/testXML'; // Changer pour l'upload de fichier
    dynamic file = File(pickedFile!.path!);

    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask = firebaseStorageRef.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    taskSnapshot.ref.getDownloadURL().then((value) {
      firestoreInstance.collection('users').doc(auth.currentUser!.uid).update({'txml': value});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UI_gradient_button(title: 'Sign', onPressed: () {
                
              })
              // UI_gradient_button(title: 'Import Document', onPressed: () {
              //   _selectFile();
              // }),
              // Text(
              //   (pickedFile!.path!),
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              // ),
              // const SizedBox(height:10), 
              // UI_gradient_button(title: 'Send Document', onPressed: () {
              //   _uploadFile();
              // }),
            ],
          ),
        ),
      ),
    );
  }
}
class File {
  var myFile = File('file.txt');
  File(Object? s);
}