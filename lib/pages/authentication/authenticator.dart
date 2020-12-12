import 'package:flutter/material.dart';
import 'package:waap/STYLES.dart';

import 'package:waap/components/WaapButton.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:waap/pages/authentication/login.dart';
import 'package:waap/pages/authentication/register.dart';

class Authentificator extends StatelessWidget {
  @override

  static double _align = 3; // goes from 3 to 1

  MaterialPageRoute get login => MaterialPageRoute(builder: (context) => LoginPage());
  MaterialPageRoute get register => MaterialPageRoute(builder: (context) => RegisterPage());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: STYLES.palette["background"],
      ),
      body: SafeArea(
        child: Container(
      decoration: BoxDecoration(
        color: STYLES.palette["background"],
        image: DecorationImage(
          image: AssetImage("assets/images/waap_splash.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment(1, 0.5),
        child: Container(
          child: TweenAnimationBuilder(
            duration: Duration(milliseconds: 1500),
            curve: Curves.bounceOut,
            tween: Tween<double>(begin: _align, end: 1),
            onEnd: (){_align=1;},
            builder: (BuildContext context, double align, Widget) {
              return Align(
                alignment: Alignment(align, 0),
                widthFactor: 2,
                heightFactor: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    WaapButton(
                        Text(
                          "login".tr().toUpperCase(),
                          style: STYLES.text["button1"],
                        ),
                        type: WaapButton.LEFT, callback: (){Navigator.push(context,login);},),
                    SizedBox(
                      height: 50,
                    ),
                    WaapButton(Text("register".tr().toUpperCase(), style: STYLES.text["button1"]),
                        type: WaapButton.LEFT, callback: (){Navigator.push(context,register);},),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    )));
  }
}
