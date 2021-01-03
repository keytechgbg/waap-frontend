import 'dart:async';

import 'package:flutter/material.dart';
import 'package:waap/STYLES.dart';

class SimpleTimer extends StatefulWidget {
  SimpleTimer(this.prefix, this.finish, this.callback);

  String prefix;
  Function callback;
  Timer t;

  DateTime finish;

  @override
  _SimpleTimerState createState() => _SimpleTimerState();
}

class _SimpleTimerState extends State<SimpleTimer> {
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

  waitingDur() {
    var now = DateTime.now();
    var sec = widget.finish.second;
    return now.second < sec ? sec - now.second : 60 - now.second + sec;
  }

  @override
  void initState() {
    print(waitingDur());
    widget.t = Timer(Duration(seconds: waitingDur()), () {

      if (widget.finish.isBefore(DateTime.now())){
        widget.t.cancel();
        widget.callback();
        return 0;
      }
      widget.t.cancel();
      widget.t = Timer.periodic(Duration(minutes: 1), (t) {
        if (widget.finish.isBefore(DateTime.now())){
          t.cancel();
          widget.callback();
          return 0;
        }
        setState(() {});
      });
      setState(() {

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget.prefix+
      properTime(widget.finish),
      style: STYLES.text["pageTitle"],
    );
  }
}
