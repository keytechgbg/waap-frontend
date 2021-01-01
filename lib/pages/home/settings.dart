import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:waap/STYLES.dart';
import 'package:waap/components/SafeScroll.dart';
import 'package:waap/components/WaapButton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waap/pages/home/show_pdf.dart';
import 'package:waap/services/api.dart';
import 'package:waap/services/shared.dart';
import 'package:waap/services/db.dart';
import 'package:path_provider/path_provider.dart';

class SettingsPage extends StatelessWidget {
  final double borderSize = 2;

  Future<File> fromAsset(String asset, String filename) async {
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    var W = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;

    return Scaffold(
      body: SafeArea(
        child: SafeScroll(
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
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "profile".tr(),
                            style: STYLES.text["base"],
                          ),
                        ),
                      ),
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "username".tr() + "&" + "password".tr(),
                                      style: STYLES.text["base"],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: GestureDetector(
                                      child: Icon(Icons.arrow_forward),
                                      onTap: () async {
                                        //TODO dopil
                                        var f = await fromAsset(
                                            "assets/pdf/privacy_policy.pdf",
                                            "privacy_policy.pdf");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ShowPdfPage(f.path)));
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                          mainAxisSize: MainAxisSize.min,
                        ),
                      ),
                    ],
                  )),
              Container(
                  padding: EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "game_options".tr(),
                            style: STYLES.text["base"],
                          ),
                        ),
                      ),
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "send_proposal".tr(),
                                      style: STYLES.text["base"],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: GestureDetector(
                                      child: Icon(Icons.arrow_forward),
                                      onTap: () async {
                                        //TODO dopil
                                        var f = await fromAsset(
                                            "assets/pdf/privacy_policy.pdf",
                                            "privacy_policy.pdf");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ShowPdfPage(f.path)));
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: borderSize),
                              padding: EdgeInsets.symmetric(vertical: 10),
                              // line size
                              color: STYLES.palette["primary"],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "game_help".tr(),
                                      style: STYLES.text["base"],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: GestureDetector(
                                      child: Icon(Icons.info_outline),
                                      onTap: () async {
                                        //TODO dopil
                                        var f = await fromAsset(
                                            "assets/pdf/privacy_policy.pdf",
                                            "privacy_policy.pdf");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ShowPdfPage(f.path)));
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                          mainAxisSize: MainAxisSize.min,
                        ),
                      ),
                    ],
                  )),
              Container(
                  padding: EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "support".tr(),
                            style: STYLES.text["base"],
                          ),
                        ),
                      ),
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "report_problem".tr(),
                                      style: STYLES.text["base"],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: GestureDetector(
                                      child: Icon(Icons.arrow_forward),
                                      onTap: () async {
                                        var f = await fromAsset(
                                            "assets/pdf/terms_of_use.pdf",
                                            "terms_of_use.pdf");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ShowPdfPage(f.path)));
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: borderSize),
                              padding: EdgeInsets.symmetric(vertical: 10),
                              // line size
                              color: STYLES.palette["primary"],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "privacy_policy".tr(),
                                      style: STYLES.text["base"],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: GestureDetector(
                                      child: Icon(Icons.arrow_forward),
                                      onTap: () async {
                                        var f = await fromAsset(
                                            "assets/pdf/privacy_policy.pdf",
                                            "privacy_policy.pdf");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ShowPdfPage(f.path)));
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: borderSize),
                              padding: EdgeInsets.symmetric(vertical: 10),
                              // line size
                              color: STYLES.palette["primary"],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "terms_of_use".tr(),
                                      style: STYLES.text["base"],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: GestureDetector(
                                      child: Icon(Icons.arrow_forward),
                                      onTap: () async {
                                        var f = await fromAsset(
                                            "assets/pdf/terms_of_use.pdf",
                                            "terms_of_use.pdf");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ShowPdfPage(f.path)));
                                      },
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                          mainAxisSize: MainAxisSize.min,
                        ),
                      ),
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: RaisedButton(
                    child: Text(
                      "log_out".tr(),
                      style: STYLES.text["title"],
                    ),
                    onPressed: () {
                      Shared.logOut();
                      DBHelper().clear();
                      API.close();
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/", (route) => false);
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
