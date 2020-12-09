import 'package:flutter/material.dart';
import 'package:waap/STYLES.dart';

import 'package:waap/components/WaapButton.dart';
// import 'package:waap/pages/authentication/login.dart';
// import 'package:waap/pages/authentication/sign_in.dart';

class Authentificator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/waap_splash.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(alignment: Alignment(1,0.75),
            child: WaapButton(Text("Login", style:  STYLES.text['button1'],),type: WaapButton.RIGHT) ,
    ),
    ));
  }
}
