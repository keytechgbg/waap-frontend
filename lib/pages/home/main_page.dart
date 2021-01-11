import 'dart:async';

import 'package:flutter/material.dart';
import 'package:waap/STYLES.dart';
import 'package:waap/components/ChallengeListItem.dart';
import 'package:waap/components/SafeScroll.dart';
import 'package:waap/components/WaapButton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waap/components/custom_icons_icons.dart';
import 'package:waap/models/Challenge.dart';
import 'package:waap/models/Friend.dart';
import 'package:waap/pages/home/finished.dart';
import 'package:waap/pages/home/new_challenge.dart';
import 'package:waap/pages/home/settings.dart';
import 'package:waap/pages/home/statistics.dart';
import 'package:waap/services/api.dart';
import 'package:waap/services/db.dart';
import 'package:waap/services/notifications.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  MaterialPageRoute get statistics =>
      MaterialPageRoute(builder: (context) => StatisticsPage());

  MaterialPageRoute get settings =>
      MaterialPageRoute(builder: (context) => SettingsPage());

  MaterialPageRoute get new_challenge =>
      MaterialPageRoute(builder: (context) => NewChallengePage());

  MaterialPageRoute get finished => MaterialPageRoute(
      builder: (context) => FinishedPage(
          challenges.where((e) => e.status == Challenge.FINISHED).toList()));

  List<String> friendshipRequests;

  List<Challenge> challenges = [];

  final double borderSize = 2;

  updateStatus(challenge) async {
    var status = challenge.status;
    if (status == Challenge.STARTED &&
        challenge.expire.isBefore(DateTime.now())) {
      status = Challenge.VOTING;
    }
    if (status == Challenge.VOTING &&
        challenge.voting.isBefore(DateTime.now())) {
      status = Challenge.FINISHED;
    }
    if (status != challenge.status) {
      challenge.status = status;
      await DBHelper().updateChallenge(challenge);
    }
    return 1;
  }

  Future<int> updateChallengesAndFriends() async {
    var db = DBHelper();
    var friends = await API.getFriends();
    if (friends is List) {
      await db.updateFriendsFromList(friends);
    }

    var flist = await db.getFriends() ?? [];
    friendshipRequests = flist
        .where((e) => e.from_user == 0 && e.status == Friend.WAITING)
        .map((e) => e.username)
        .toList()
        .cast<String>();

    Map challengeList = await API.getChallenges() ?? {};
    if (challengeList.isNotEmpty) {
      if (challengeList.containsKey("challenges")) {
        await db.updateChallengesFromList(challengeList["challenges"]);
      } else
        await db.updateChallengesFromList([]);
    }
    var clist = await db.getChallenges() ?? [];

    if (challengeList.isEmpty) {
      for (var i = 0; i < clist.length; i++) {
        if (clist[i].status == Challenge.FINISHED) continue;
        await updateStatus(clist[i]);
      }
    }

    if (clist.length > 1) {
      clist.sort((a, b) {
        var res;
        if (a.status > b.status)
          res = -1;
        else if (a.status < b.status)
          res = 1;
        else if (a.status == Challenge.STARTED ) {
          if (a.expire.isBefore(b.expire))
            res = -1;
          else
            res = 1;
        } else if (a.status == Challenge.FINISHED ) {
          if (a.expire.isBefore(b.expire))
            res = 1;
          else
            res = -1;
        } else if (a.status == Challenge.VOTING) {
          if (a.voting.isBefore(b.voting))
            res = -1;
          else
            res = 1;
        }
        return res;
      });
    }
    challenges = clist;
    return 1;
  }

  String properTime(DateTime dt) {
    if (dt.isBefore(DateTime.now())) {
      return "0d0h0m";
    }
    Duration dur = dt.difference(DateTime.now());

    var d = dur.inDays;
    var h = dur.inHours;
    var m = dur.inMinutes;

    return d.toString() +
        "d" +
        (h - d * 24).toString() +
        "h" +
        (m - h * 60).toString() +
        "m";
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
                padding:
                    STYLES.buttonTopPadding.add(EdgeInsets.only(bottom: 25)),
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
                      callback: () async {
                        var res = await Navigator.push(context, new_challenge);
                        if (res) setState(() {});
                      },
                    ),
                  ],
                )),
            Expanded(
                child: SafeScroll(
                    child: Padding(
              padding: const EdgeInsets.only(top: 25),
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
                  ),
                  FutureBuilder(
                      future: updateChallengesAndFriends(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          NotificationService.sheduledFromList(challenges.where((e) =>
                          e.status != Challenge.FINISHED).take(5).toList());

                          return Container(
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.only(bottom: borderSize),
                                  child: Column(
                                    children: challenges
                                        .where((e) =>
                                            e.status != Challenge.FINISHED)
                                        .map((_) => ChallengeListItem(_, () {
                                              setState(() {});
                                            }))
                                        .toList(),
                                    mainAxisSize: MainAxisSize.min,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                (friendshipRequests.isEmpty)
                                    ? Container()
                                    : Container(
                                        width: double.infinity,
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "friend_requests".tr(),
                                                style: STYLES.text["title"],
                                              ),
                                            ),
                                            Container(
                                              color: Colors.white,
                                              padding: EdgeInsets.only(
                                                  bottom: borderSize),
                                              child: Column(
                                                children: friendshipRequests
                                                    .map((_) => Container(
                                                          margin: EdgeInsets.only(
                                                              top: borderSize),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10),
                                                          // line size
                                                          color: STYLES.palette[
                                                              "primary"],
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Flexible(
                                                                flex: 3,
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              15),
                                                                  child: Text(
                                                                    _,
                                                                    style: STYLES
                                                                            .text[
                                                                        "title"],
                                                                  ),
                                                                ),
                                                              ),
                                                              Flexible(
                                                                  child: Row(
                                                                children: [
                                                                  IconButton(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .close),
                                                                      color: Colors
                                                                          .red,
                                                                      iconSize:
                                                                          30,
                                                                      onPressed:
                                                                          () async {
                                                                        var res = await API.updateFriend(
                                                                            _,
                                                                            Friend.STATUSES[Friend.REJECTED]);

                                                                        if (res
                                                                            is List)
                                                                          setState(() {});
                                                                      }),
                                                                  IconButton(
                                                                      icon: Icon(Icons
                                                                          .check),
                                                                      color: Colors
                                                                              .green[
                                                                          900],
                                                                      iconSize:
                                                                          30,
                                                                      onPressed:
                                                                          () async {
                                                                        var res = await API.updateFriend(
                                                                            _,
                                                                            Friend.STATUSES[Friend.ACCEPTED]);
                                                                        if (res
                                                                            is List)
                                                                          setState(() {});
                                                                      })
                                                                ],
                                                              ))
                                                            ],
                                                          ),
                                                        ))
                                                    .toList(),
                                                mainAxisSize: MainAxisSize.min,
                                              ),
                                            ),
                                          ],
                                        ))
                              ],
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          print(snapshot.error);
                          return Container(
                            alignment: Alignment.center,
                            child: Text(
                              "network_connection_error".tr(),
                              style: STYLES.text["error"],
                            ),
                          );
                        }
                        return Container(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            backgroundColor: STYLES.palette["primary"],
                            strokeWidth: 4,
                          ),
                        );
                      })
                ],
              ),
            ))),
            SizedBox(
              height: 20,
            ),
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
                      type: WaapButton.BOTH,
                      callback: () {
                        Navigator.push(context, finished);
                      },
                    ),
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
