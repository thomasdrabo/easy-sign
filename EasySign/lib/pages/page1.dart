import 'package:easy_sign/services/authHelpers/firebase-auth-helper.dart';
import 'package:easy_sign/widgets/buttons/ui_gradient_button.dart';
import 'package:flutter/material.dart';

import '../wrapper.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: SafeArea(
        child: Container(
          child: Center(
            child: UI_gradient_button(title: 'LogOut', onPressed: (){
              FirebaseAuthHelper().logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Wrapper()),
              );
            }),
          ),
        ),
      ),
    );
  }
}
