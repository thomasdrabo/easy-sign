import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/user.dart';
import '../widgets/buttons/ui_gradient_button.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {

    return Container(
        child: Builder(
        builder: (context) => Scaffold(
      appBar: AppBar(),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 24),
          buildName(),
          const SizedBox(height: 24),
          const SizedBox(height: 24),
          const SizedBox(height: 48),
          buildAbout(),
          buildInfos()
        ]
    )
    )
    )
    );
  }

    Widget buildName() => Column(
    children: [
    Text(
    "Username",
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
    ),
    const SizedBox(height: 4),
    Text(
    "Mail",
    style: TextStyle(color: Colors.grey),
    )
    ],
    );


    Widget buildAbout() => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'About',
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 16),
    Text(
    "about informations bla bla bla",
    style: TextStyle(fontSize: 16, height: 1.4),
    ),
    ],
    ),
    );

  Widget buildInfos() => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Infos',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          "infos infos",
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
        Text(
          'Superieur',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          "boss boss boss",
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
        Text(
          'Poste',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          "pute pute pute",
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
      ],
    ),
  );

}