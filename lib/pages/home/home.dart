import 'package:waap/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:waap/STYLES.dart';



class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: STYLES.palette["background"],
        appBar: AppBar(
          backgroundColor: STYLES.palette["notifBar"],
        ),
        body: SafeArea(child: Container(child: RaisedButton(child: Text("Sign out"), onPressed: _auth.signOut,),),
        ));
  }
}