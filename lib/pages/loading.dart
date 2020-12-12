import 'package:flutter/material.dart';
import 'package:waap/STYLES.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container( width: double.infinity, height:double.infinity, decoration: BoxDecoration(color:STYLES.palette["background"] ,
     /* image: DecorationImage(
        image: AssetImage("assets/images/waap_splash.png"),
        fit: BoxFit.cover,
      ),*/
    ),);
  }
}
