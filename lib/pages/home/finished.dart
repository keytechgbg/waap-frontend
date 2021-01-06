import 'package:flutter/material.dart';
import 'package:waap/STYLES.dart';
import 'package:waap/components/SafeScroll.dart';
import 'package:waap/components/WaapButton.dart';
import 'package:waap/models/Challenge.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waap/pages/home/challenge_finished.dart';

class FinishedPage extends StatelessWidget {
  List<Challenge> challenges;
  FinishedPage(this.challenges);

  final double borderSize = 2;


  String properTime(DateTime dt) {

    var y = dt.year;
    var m = dt.month;
    var d = dt.day;

    return y.toString() +
        "-" +
        m.toString() +
        "-" +
        d.toString();
  }


  @override
  Widget build(BuildContext context) {
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
                    child: Align(alignment: Alignment.center,
                      child: Text(
                        "finished_games".tr(),
                        style: STYLES.text["pageTitle"],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: SafeScroll(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                                      "date".tr(),
                                      style: STYLES.text["title"],
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(bottom: borderSize),
                            child: Column(
                              children: challenges
                                  .map((_) => GestureDetector(onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChallengeFinishedPage(_)));
                              },

                                    child: Container(
                                margin: EdgeInsets.only(top: borderSize),
                                padding: EdgeInsets.symmetric(
                                      vertical: 20), // line size
                                color: STYLES.palette["primary"],
                                child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      Flexible(
                                        child: Container(
                                          child: Center(
                                            child: Text(
                                              _.users.length.toString(),
                                              style: STYLES.text["base"],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: Container(
                                          child: Center(
                                            child: Text(
                                              _.theme,
                                              style: STYLES.text["base"],
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          child: Center(
                                            child: Text(
                                              properTime(_.expire),
                                              style: STYLES.text["base"],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                ),
                              ),
                                  ))
                                  .toList(),
                              mainAxisSize: MainAxisSize.min,
                            ),
                          )
                        ],
                      ),
                    ))),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
