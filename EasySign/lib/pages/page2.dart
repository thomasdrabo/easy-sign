import 'package:easy_sign/services/authHelpers/firebase-auth-helper.dart';
import 'package:easy_sign/widgets/buttons/ui_gradient_button.dart';
import 'package:easy_sign/widgets/xml/intervention_form.dart';
import 'package:easy_sign/wrapper.dart';
import 'package:flutter/material.dart';

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Container(
          child: Center(
                child: UI_gradient_button(
                    title: 'LogOut',
                    onPressed: () {
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