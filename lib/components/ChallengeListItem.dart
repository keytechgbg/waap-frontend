import 'dart:async';

import 'package:flutter/material.dart';
import 'package:waap/components/ExitChallengeDialog.dart';
import 'package:waap/models/Challenge.dart';
import 'package:waap/pages/home/challenge_detail.dart';
import 'package:waap/services/db.dart';

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
  Timer timer;

  ChallengeListItem(this.challenge, this.update) {}

  @override
  _ChallengeListItemState createState() => _ChallengeListItemState();
}

class _ChallengeListItemState extends State<ChallengeListItem> {
  final double borderSize = 2;

  waitingDur() {
    var now = DateTime.now();
    var sec = widget.challenge.status== Challenge.STARTED ? widget.challenge.expire.second: widget.challenge.voting.second;
    return now.second < sec ? sec - now.second : 60 - now.second + sec;
  }

  updateStatus(t) {

    var status=widget.challenge.status;

    if (status==Challenge.FINISHED){
      t.cancel();
      return 0;
    }
    if (status == Challenge.STARTED &&
        widget.challenge.expire.isBefore(DateTime.now())) {
      status = Challenge.VOTING;
    }
    if (status == Challenge.VOTING &&
        widget.challenge.voting.isBefore(DateTime.now())) {
      status = Challenge.FINISHED;
    }
    if (status != widget.challenge.status) {
      widget.challenge.status = status;
      updateDB(t);
    }

    try{
      setState(() {});
    }catch(e){t.cancel();}
  }

  updateDB(t) async{
    await DBHelper().updateChallenge(widget.challenge);
    t?.cancel();
    widget.update();
  }

  initTimer()async{

    widget.timer = await Future.delayed(Duration(seconds: waitingDur()),() => Timer.periodic(Duration(minutes: 1), updateStatus));
    try{
      setState(() {
        updateStatus(widget.timer);
        print(widget.challenge.status);
      });
    }catch(e){}
  }


  @override
  void didUpdateWidget(ChallengeListItem oldWidget) {

    if(oldWidget.timer!=null){try{oldWidget.timer.cancel(); }catch(e){}}

    if(widget.timer==null){initTimer();}
    else{
    widget.timer.cancel();
    initTimer();
    }
  }

  @override
  void initState() {
    initTimer();
    // Future.delayed(Duration(seconds: 1), updateStatus(1));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onLongPress: ()async{

        var answer = await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) =>
                ExitChallengeDialog(widget.challenge, widget.update, ));
        print(answer);
      },
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChallengeDetailPage(widget.challenge)));
      },
      child: Container(
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
      ),
    );
  }
}
