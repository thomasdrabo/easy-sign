import 'package:easy_sign/pages/authentification/connection.dart';
import 'package:easy_sign/pages/authentification/register.dart';
import 'package:easy_sign/widgets/bars/ui_switch_bar.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10,),
            UI_switch_bar(title_left: "Se connecter", title_right: "S'inscrire", onclick_left: () {
              _controller.animateToPage(0, duration: Duration(milliseconds: 250), curve: Curves.decelerate);
            }, onclick_right: () {
              _controller.animateToPage(1, duration: Duration(milliseconds: 250), curve: Curves.decelerate);
            }),
            Expanded(
              child: Container(
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _controller,
                  children: [
                    Column(
                      children: [
                        Connection(),
                      ],
                    ),
                    Column(
                      children: [
                        Register(),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
