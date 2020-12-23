import 'dart:async';

import 'package:flutter/material.dart';
import 'package:waap/models/Challenge.dart';

import '../STYLES.dart';

class ChallengeListItem extends StatefulWidget {
  static String properTime(DateTime dt) {
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

  Function update;

  Challenge challenge;
  Future timer;

  ChallengeListItem(this.challenge, this.update) {}

  @override
  _ChallengeListItemState createState() => _ChallengeListItemState();
}

class _ChallengeListItemState extends State<ChallengeListItem> {
  final double borderSize = 2;

  waitingDur() {
    var now = DateTime.now();
    var sec = widget.challenge.expire.second;
    return now.second < sec ? sec - now.second : 60 - now.second + sec;
  }

  @override
  void initState() {
    widget.timer = Future.delayed(
        Duration(seconds: waitingDur()),
        () => Timer.periodic(Duration(minutes: 1), (t) {
              if ((widget.challenge.status == Challenge.STARTED &&
                      widget.challenge.expire.isBefore(DateTime.now())) ||
                  (widget.challenge.status == Challenge.VOTING &&
                      widget.challenge.voting.isBefore(DateTime.now()))) {widget.update();}
              setState(() {});
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: borderSize),
      padding: EdgeInsets.symmetric(vertical: 20),
      // line size
      color: STYLES.palette["primary"],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            child: Container(
              child: Center(
                child: Text(
                  widget.challenge.users.length.toString(),
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
                  widget.challenge.theme,
                  style: STYLES.text["base"],
                ),
              ),
            ),
          ),
          Flexible(
            child: Container(
              child: Center(
                child: Text(
                  ChallengeListItem.properTime(widget.challenge.expire),
                  style: STYLES.text["base"],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
