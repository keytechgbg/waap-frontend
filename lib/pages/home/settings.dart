import 'package:flutter/material.dart';

import 'package:waap/STYLES.dart';
import 'package:waap/components/WaapButton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waap/services/shared.dart';

class SettingsPage extends StatelessWidget {
  final double borderSize = 2;

  @override
  Widget build(BuildContext context) {
    var W = MediaQuery
        .of(context)
        .size
        .width -
        MediaQuery
            .of(context)
            .padding
            .left -
        MediaQuery
            .of(context)
            .padding
            .right;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: STYLES.buttonTopPadding,
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: WaapButton(
                        Icon(Icons.arrow_back),
                        type: WaapButton.RIGHT,
                        callback: () {
                          Navigator.pop(context);
                        },
                      )),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "settings".tr(),
                        style: STYLES.text["pageTitle"],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 50),
                child: FutureBuilder<Map<String, int>>(
                  future: Shared.getStats(),
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<String, int>> snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return Container();
                    }
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(bottom: borderSize),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: borderSize),
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  // line size
                                  color: STYLES.palette["primary"],
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text("setting №1",
                                        style: STYLES.text["title"],),
                                    ), Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: GestureDetector(
                                        child: Icon(Icons.arrow_forward),
                                        onTap: () {
                                        },),
                                    )
                                    ],
                                  ),
                                )
                              ],
                              mainAxisSize: MainAxisSize.min,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: RaisedButton(child: Text(
                                "log_out".tr(),
                                style: STYLES.text["title"],

                              ), onPressed: () {
                                Shared.logOut();
                                Navigator.pushNamedAndRemoveUntil(
                                    context, "/", (route) => false);
                              }
                                ,
                              ))
                        ],
                      );
                    }
                    return Container(
                      height: 60,
                      color: Colors.red,
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}
