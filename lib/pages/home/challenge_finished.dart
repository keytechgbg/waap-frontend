import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:waap/STYLES.dart';
import 'package:waap/components/SafeScroll.dart';
import 'package:waap/components/WaapButton.dart';
import 'package:waap/components/custom_icons_icons.dart';
import 'package:waap/models/Challenge.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waap/models/Photo.dart';
import 'package:waap/pages/home/congratulations.dart';
import 'package:waap/pages/home/photoview.dart';
import 'package:waap/services/api.dart';
import 'package:waap/services/db.dart';
import 'package:waap/services/shared.dart';
import 'package:waap/models/Photo.dart';

class ChallengeFinishedPage extends StatelessWidget {
  ChallengeFinishedPage(this.challenge) {
    setUsername();
  }

  Challenge challenge;

  final double borderSize = 2;

  final double squareSpace = 40;

  List<Map<String, dynamic>> photos = [];

  String _username;

  setUsername() async {
    _username = _username ?? await Shared.getUsername();
    return _username;
  }

  var picker = ImagePicker();

  addPhoto(File file, Photo photo) {
    photos.add({"photo": photo, "file": file});
  }

  Future<int> updatePhotos() async {
    var db = DBHelper();
    var response = await API.getPhotos(challenge.id);
    var likes = await API.getLikes(challenge.id);

    if (response is List && likes is List) {
      var preparedList = [];
      for (var e in response) {
        preparedList.addAll(e["photos"]
            .map((p) =>
        {
          "owner": e["user"],
          "url": p["url"],
          "likes": p["likes"],
          "liked": likes.first["photos"].contains(p["url"]) ? 1 : 0
        })
            .toList());
      }
      await db.updatePhotosFromList(preparedList, challenge.id);
    }

    var plist = await db.getPhotos(challenge.id) ?? [];
    if (plist.isNotEmpty) {
      for (var p in plist) {
        var file = await API.getDownloadedPhoto(challenge.id, p.url) ??
            await API.downloadPhoto(challenge.id, p.url);
        if (file != null) {
          addPhoto(file, p);
        }
      }
    }

    return 1;
  }



  List names;
  List properNames(){
    if(names!=null)
      return names;
    names=photos.map((e) => e["photo"].owner).toSet().toList();
    return names;
  }


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

    var H = MediaQuery
        .of(context)
        .size
        .height -
        MediaQuery
            .of(context)
            .padding
            .top -
        MediaQuery
            .of(context)
            .padding
            .bottom;

    double square = ((W - squareSpace) ~/ 3).toDouble();

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: H,
          width: W,
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
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      Container(
                        width: W,
                        color: Colors.white,
                        padding: EdgeInsets.only(bottom: borderSize),
                        child: Container(
                            margin: EdgeInsets.only(top: borderSize),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            // line size
                            color: STYLES.palette["primary"],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(right: 10),
                                          child: Text("game".tr() + ":",
                                              style:
                                              STYLES.text["optionTitle"]),
                                        ),
                                        Flexible(
                                          child: Text(challenge.theme,
                                              style:
                                              STYLES.text["optionTitle"]),
                                        )
                                      ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(right: 10),
                                          child: Text("reward".tr() + ":",
                                              style:
                                              STYLES.text["optionTitle"]),
                                        ),
                                        Flexible(
                                          child: Text(challenge.reward,
                                              style:
                                              STYLES.text["optionTitle"]),
                                        )
                                      ]),
                                ),
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(right: 10),
                                      child: Text("players".tr() + ":",
                                          style:
                                          STYLES.text["optionTitle"]),
                                    ),
                                  ].cast<Widget>() +
                                      challenge.users
                                          .map((e) =>
                                          Container(
                                            padding: EdgeInsets.all(3),
                                            margin: EdgeInsets.all(2),
                                            color: STYLES.palette["accent"],
                                            child: Text(
                                              e,
                                              style: STYLES
                                                  .text["optionTitle"]
                                                  .copyWith(
                                                  color: Colors.black),
                                            ),
                                          ))
                                          .toList()
                                          .cast<Widget>(),
                                ),
                              ],
                            )),
                      ),
                      Expanded(
                        child: FutureBuilder(
                            future: updatePhotos(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) print(snapshot.error);
                              if (snapshot.hasData) {

                                if (challenge.winners == null) {
                                  List sorted = photos.toList();
                                  sorted.sort((a, b) =>
                                  a["photo"].likes > b["photo"].likes ? -1 : 1);
                                  sorted =
                                      sorted.where((e) =>
                                      e["photo"].likes ==
                                          sorted.first["photo"].likes).toList();
                                  var names = sorted.map((e) =>
                                  e["photo"].owner)
                                      .toList();
                                  challenge.winners=names.toSet().join(" ");
                                  DBHelper().updateChallenge(challenge);
                                  if (names
                                      .contains(_username)) {
                                    SchedulerBinding.instance.addPostFrameCallback((_) {
                                       Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Congratulations(sorted[names
                                                          .indexOf(_username)]
                                                      ["file"])));
                                    });
                                  }

                                }

                                return SafeScroll(
                                  child: Column(
                                    children: properNames()
                                        .map((u) =>
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Align(
                                                  alignment:
                                                  Alignment.centerLeft,
                                                  child: Text(
                                                    u,
                                                    style: STYLES.text["title"],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    top: 5),
                                                child: Row(
                                                  children: photos
                                                      .where((e) =>
                                                  e["photo"].owner ==
                                                      u)
                                                      .toList()
                                                      .map((e) =>
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left:
                                                            squareSpace /
                                                                4),
                                                        child: e == null
                                                            ? Container()
                                                            : GestureDetector(
                                                          onTap:
                                                              () async {
                                                            await Navigator
                                                                .push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (
                                                                        context) =>
                                                                        PhotoviewPage(
                                                                            photos,
                                                                            photos
                                                                                .indexOf(
                                                                                e),
                                                                            Challenge
                                                                                .FINISHED,
                                                                            challenge
                                                                                .id)));
                                                          },
                                                          child:
                                                          Container(
                                                            child:
                                                            Stack(
                                                              children: [
                                                                Container(
                                                                  width: square,
                                                                  height: square,
                                                                  child: Hero(
                                                                    tag: e["file"]
                                                                        .path,
                                                                    child: Image
                                                                        .file(
                                                                      e["file"],
                                                                      gaplessPlayback: true,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Align(
                                                                  alignment: Alignment
                                                                      .topRight,
                                                                  child: (e["photo"]
                                                                      .liked ==
                                                                      1)
                                                                      ? Container(
                                                                    color: STYLES
                                                                        .palette["primary"],
                                                                    child: Icon(
                                                                      CustomIcons
                                                                          .heart,
                                                                      size: 20,
                                                                      color: STYLES
                                                                          .palette["accent"],
                                                                    ),
                                                                  )
                                                                      : Container(),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        width: square,
                                                        height: square,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white,
                                                                width:
                                                                borderSize)),
                                                      )
                                                  )
                                                      .toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                        .toList(),
                                  ),
                                );
                                ;
                              }
                              return Container(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  backgroundColor: STYLES.palette["primary"],
                                  strokeWidth: 4,
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
