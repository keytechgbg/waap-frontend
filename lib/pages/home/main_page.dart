import 'package:flutter/material.dart';
import 'package:waap/STYLES.dart';
import 'package:waap/components/WaapButton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waap/components/custom_icons_icons.dart';
import 'package:waap/pages/home/new_challenge.dart';
import 'package:waap/pages/home/settings.dart';
import 'package:waap/pages/home/statistics.dart';

class MainPage extends StatelessWidget {
  MaterialPageRoute get statistics =>
      MaterialPageRoute(builder: (context) => StatisticsPage());

  MaterialPageRoute get settings =>
      MaterialPageRoute(builder: (context) => SettingsPage());

  MaterialPageRoute get new_challenge =>
      MaterialPageRoute(builder: (context) => NewChallengePage());

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
                padding:
                    STYLES.buttonTopPadding.add(EdgeInsets.only(bottom: 50)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WaapButton(
                      Icon(Icons.settings),
                      type: WaapButton.RIGHT,
                      callback: () {
                        Navigator.push(context, settings);
                      },
                    ),
                    Text(
                      "waap".tr(),
                      style: STYLES.text["mainTitle"],
                    ),
                    WaapButton(
                      Icon(Icons.add),
                      type: WaapButton.LEFT,
                      callback: () {
                        Navigator.push(context, new_challenge);
                      },
                    ),
                  ],
                )),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "waap".tr() + " " + "challenges".tr(),
                    style: STYLES.text["pageTitle"],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: Text(
                        "players".tr(),
                        style: STYLES.text["title"],
                      )),
                      Flexible(
                          flex: 2,
                          child: Text(
                            "challenge".tr(),
                            style: STYLES.text["title"],
                          )),
                      Flexible(
                          child: Text(
                        "time_left".tr(),
                        style: STYLES.text["title"],
                      )),
                    ],
                  ),
                )
              ],
            ))),
            Container(
                padding: EdgeInsets.only(bottom: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WaapButton(
                      Icon(Icons.bar_chart),
                      type: WaapButton.RIGHT,
                      callback: () {
                        Navigator.push(context, statistics);
                      },
                    ),
                    WaapButton(
                        Text(
                          "finished_games".tr().toUpperCase(),
                          style: STYLES.text["button2"],
                        ),
                        type: WaapButton.BOTH),
                    WaapButton(
                      Icon(CustomIcons.hq),
                      type: WaapButton.LEFT,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
