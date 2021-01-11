import 'package:flutter/material.dart';
import 'package:waap/STYLES.dart';
import 'package:waap/components/TimePicker.dart';
import 'package:waap/components/WaapButton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waap/components/SafeScroll.dart';
import 'package:waap/services/api.dart';
import 'package:waap/services/db.dart';
import 'friends.dart';

class NewChallengePage extends StatefulWidget {
  @override
  _NewChallengePageState createState() => _NewChallengePageState();
}

class _NewChallengePageState extends State<NewChallengePage> {
  final double borderSize = 3;

  List<String> themes = [];

  var currenttheme;

  List<String> players = [];

  int image_count;
  Duration expire = Duration(minutes: 0), voting = Duration(minutes: 0);
  TextEditingController c_theme = new TextEditingController(),
      c_reward = new TextEditingController();

  String properTime(Duration dur) {
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

  bool allFilledCheck() {
    return (image_count != null) &
        (c_theme.text != "") &
        (c_reward.text != "") &
        (expire.inMinutes != 0) &
        (voting.inMinutes != 0) &
        (players.isNotEmpty);
  }

  setExpire(Duration dur) {
    setState(() {
      expire = dur;
    });
  }

  setVoting(Duration dur) {
    setState(() {
      voting = dur;
    });
  }

  bool waiting = false;

  bool updated = false;

  updateProposals() async {
    if (updated)
      return 1;
    updated=true;

    var db = DBHelper();
    var proposals = await API.getProposals();
    if (proposals != null) {
      await db.updateProposalsFromList(proposals);
    }

    var plist = await db.getProposals() ?? [];

    themes = plist;
    currenttheme = plist.isNotEmpty ? plist[0] : null;
    c_theme.text=currenttheme ?? "";

    return 1;
  }

  @override
  Widget build(BuildContext context) {
    var W = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: updateProposals(),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return SafeScroll(
                  child: SizedBox(
                    width: W,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                                      Navigator.pop(context, true);
                                    },
                                  )),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "game_options".tr(),
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
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.only(bottom: borderSize),
                                  child: Container(
                                      margin: EdgeInsets.only(top: borderSize),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      // line size
                                      color: STYLES.palette["primary"],
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: players
                                                  .map((e) => Container(
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        margin:
                                                            EdgeInsets.all(2),
                                                        color: STYLES
                                                            .palette["accent"],
                                                        child: Text(
                                                          e,
                                                          style: STYLES.text[
                                                                  "optionTitle"]
                                                              .copyWith(
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                      ))
                                                  .toList(),
                                            ),
                                          ),
                                          Container(
                                              margin: EdgeInsets.all(2),
                                              child: GestureDetector(
                                                child: Icon(Icons.person_add),
                                                onTap: () async {
                                                  players = await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              FriendsPage(
                                                                  players)));
                                                  setState(() {});
                                                },
                                              ))
                                        ],
                                      )),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.only(bottom: borderSize),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                          margin:
                                              EdgeInsets.only(top: borderSize),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10),
                                          // line size
                                          color: STYLES.palette["primary"],
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    "nr_of_photographs".tr(),
                                                    style: STYLES
                                                        .text["optionTitle"]),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  FlatButton(
                                                      minWidth: 0,
                                                      shape: CircleBorder(
                                                          side: BorderSide(
                                                              color: STYLES
                                                                      .palette[
                                                                  "border"],
                                                              width:
                                                                  image_count ==
                                                                          1
                                                                      ? borderSize
                                                                      : 0)),
                                                      onPressed: () {
                                                        setState(() {
                                                          image_count = 1;
                                                        });
                                                      },
                                                      child: Container(
                                                        width: 45,
                                                        height: 45,
                                                        child: Center(
                                                          child: Text(
                                                            "1",
                                                            style: STYLES.text[
                                                                "imageCount"],
                                                          ),
                                                        ),
                                                      )),
                                                  FlatButton(
                                                      minWidth: 0,
                                                      shape: CircleBorder(
                                                          side: BorderSide(
                                                              color: STYLES
                                                                      .palette[
                                                                  "border"],
                                                              width:
                                                                  image_count ==
                                                                          2
                                                                      ? borderSize
                                                                      : 0)),
                                                      onPressed: () {
                                                        setState(() {
                                                          image_count = 2;
                                                        });
                                                      },
                                                      child: Container(
                                                        width: 45,
                                                        height: 45,
                                                        child: Center(
                                                          child: Text(
                                                            "2",
                                                            style: STYLES.text[
                                                                "imageCount"],
                                                          ),
                                                        ),
                                                      )),
                                                  FlatButton(
                                                      minWidth: 0,
                                                      shape: CircleBorder(
                                                          side: BorderSide(
                                                              color: STYLES
                                                                      .palette[
                                                                  "border"],
                                                              width:
                                                                  image_count ==
                                                                          3
                                                                      ? borderSize
                                                                      : 0)),
                                                      onPressed: () {
                                                        setState(() {
                                                          image_count = 3;
                                                        });
                                                      },
                                                      child: Container(
                                                        width: 45,
                                                        height: 45,
                                                        child: Center(
                                                          child: Text(
                                                            "3",
                                                            style: STYLES.text[
                                                                "imageCount"],
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              )
                                            ],
                                          )),
                                      Container(
                                          margin:
                                              EdgeInsets.only(top: borderSize),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10),
                                          // line size
                                          color: STYLES.palette["primary"],
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    "waap_challenge".tr(),
                                                    style: STYLES
                                                        .text["optionTitle"]),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20),
                                                  child: DropdownButton(
                                                    dropdownColor: Colors.white,
                                                    underline: Container(),
                                                    isExpanded: true,
                                                    value: currenttheme,
                                                    onChanged: (s) {
                                                      setState(() {
                                                        currenttheme = s;
                                                        c_theme.text = s;
                                                      });
                                                    },
                                                    items: themes
                                                        .map((e) =>
                                                            DropdownMenuItem(
                                                                value: e,
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: STYLES
                                                                            .palette[
                                                                        "primary"],
                                                                  ),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    e,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 1,
                                                                    style: STYLES
                                                                            .text[
                                                                        "title"],
                                                                  ),
                                                                )))
                                                        .toList(),
                                                  )
                                                  // child: TextField(
                                                  //   controller: c_theme,
                                                  //   enableSuggestions: false,
                                                  //   enableInteractiveSelection: false,
                                                  //   autocorrect: false,
                                                  //   decoration: STYLES.optionsTextField,
                                                  //   style: STYLES.text["optionTextField"],
                                                  //   maxLengthEnforced: true,
                                                  //   cursorColor: Colors.white,
                                                  //   maxLength: 50,
                                                  //   maxLines: 1,
                                                  // ),
                                                  )
                                            ],
                                          )),
                                      Container(
                                          margin:
                                              EdgeInsets.only(top: borderSize),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10),
                                          // line size
                                          color: STYLES.palette["primary"],
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("game_time".tr(),
                                                  style: STYLES
                                                      .text["optionTitle"]),
                                              Text(properTime(expire),
                                                  style: STYLES.text["base"]),
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                icon: Icon(
                                                  Icons.access_time_outlined,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) =>
                                                          TimePickerDialog(
                                                            text: "game_time"
                                                                .tr(),
                                                            callback: setExpire,
                                                          ));
                                                },
                                              )
                                            ],
                                          )),
                                      Container(
                                          margin:
                                              EdgeInsets.only(top: borderSize),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10),
                                          // line size
                                          color: STYLES.palette["primary"],
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("voting_time".tr(),
                                                  style: STYLES
                                                      .text["optionTitle"]),
                                              Text(properTime(voting),
                                                  style: STYLES.text["base"]),
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                icon: Icon(
                                                  Icons.access_time_outlined,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) =>
                                                          TimePickerDialog(
                                                            text: "voting_time"
                                                                .tr(),
                                                            callback: setVoting,
                                                          ));
                                                },
                                              )
                                            ],
                                          )),
                                      Container(
                                          margin:
                                              EdgeInsets.only(top: borderSize),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10),
                                          // line size
                                          color: STYLES.palette["primary"],
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text("reward".tr(),
                                                    style: STYLES
                                                        .text["optionTitle"]),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: TextField(
                                                  controller: c_reward,
                                                  enableSuggestions: false,
                                                  enableInteractiveSelection:
                                                      false,
                                                  autocorrect: false,
                                                  decoration:
                                                      STYLES.optionsTextField,
                                                  style: STYLES
                                                      .text["optionTextField"],
                                                  maxLengthEnforced: true,
                                                  cursorColor: Colors.white,
                                                  maxLength: 50,
                                                  maxLines: 1,
                                                ),
                                              )
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 40),
                                      child: RaisedButton(
                                        child: Text(
                                          "create_challenge".tr(),
                                          style: STYLES.text["title"],
                                        ),
                                        onPressed: allFilledCheck()
                                            ? () async {
                                                if (!waiting) {
                                                  waiting = true;

                                                  try {
                                                    print("start");
                                                    await API.addChallenge(
                                                        players.join(" "),
                                                        image_count,
                                                        expire.inSeconds,
                                                        voting.inSeconds,
                                                        c_theme.text,
                                                        c_reward.text);
                                                  } catch (e) {
                                                    print("error");
                                                    waiting = false;
                                                    return;
                                                  }
                                                  Navigator.pop(context, true);
                                                }
                                              }
                                            : null,
                                      )),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                );
              return Center(
                child: Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    backgroundColor: STYLES.palette["primary"],
                    strokeWidth: 4,
                  ),
                ),
              );
            }),
      ),
    );
  }
}
