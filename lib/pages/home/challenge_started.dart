import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:waap/STYLES.dart';
import 'package:waap/components/WaapButton.dart';
import 'package:waap/models/Challenge.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waap/models/Photo.dart';
import 'package:waap/pages/home/photoview.dart';
import 'package:waap/services/api.dart';
import 'package:waap/services/db.dart';
import 'package:waap/services/shared.dart';

class ChallengeStartedPage extends StatefulWidget {
  ChallengeStartedPage(this.challenge);

  Challenge challenge;

  @override
  _ChallengeStartedPageState createState() => _ChallengeStartedPageState();
}

class _ChallengeStartedPageState extends State<ChallengeStartedPage> {
  final double borderSize = 2;

  final double squareSpace = 40;

  List<Map<String, dynamic>> photos;

  String _username;

  Timer t;

  bool SENDING= false;

  setUsername() async {
    _username = _username ?? await Shared.getUsername();
    return _username;
  }

  var picker = ImagePicker();

  addPhoto(File file, [Photo photo]) {
    int i;
    for (i = 0; i < photos.length - 1; i++) {
      if (photos[i] == null) break;
    }
    photos[i] = {"photo": photo, "file": file};
  }

  Future getImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50,);

    setState(() {
      if (pickedFile != null) {
        print(pickedFile.path);
        addPhoto(File(pickedFile.path));
      } else {
        print('No image selected.');
      }
    });
  }

  Future<int> updatePhotos() async {
    var db = DBHelper();
    var response = await API.getPhotos(widget.challenge.id);


    if (response is List) {
      var preparedList = response
          .where((e) => e["user"] == _username)
          .toList()
          .first["photos"]
          .map((e) {
        e["owner"] = _username;
        return e;
      }).toList();

      await db.updatePhotosFromList(preparedList, widget.challenge.id);
    }


    var plist = await db.getPhotos(widget.challenge.id) ?? [];
    if (plist.isNotEmpty) {
      var myPhotos = plist.where((e) => e.owner == _username).toList();

      var existing = photos
          .where((e) => e != null && e["photo"] != null)
          .map((e) => e["photo"].url)
          .toList();
      for (var p in myPhotos) {
        if (!existing.contains(p.url)) {
          var file = await API.getDownloadedPhoto(widget.challenge.id, p.url) ??
              await API.downloadPhoto(widget.challenge.id, p.url);
          if (file != null) {
            addPhoto(file, p);
          }
        }
      }
    }

    return 1;
  }

  sendPhotos() async {

    bool change= false;

    if(SENDING)
      return 0;
    SENDING=true;
    setState(() {

    });
    var newPhotos = photos.where((e) => e != null && e["photo"] == null).toList();
    for (var p in newPhotos) {
      var res = await API.addPhoto(widget.challenge.id, p["file"]);
      if (res is Map && res.containsKey("url")) {
        p["photo"] = Photo(url: res["url"], owner: _username);
        change=true;
      }
    }
    SENDING=false;
    if(widget!=null){
      setState(() {});
    }
  }

  @override
  void initState() {
    setUsername();
    photos = List(widget.challenge.image_count);
  }


  @override
  Widget build(BuildContext context) {

    t?.cancel();
    t=Timer(widget.challenge.expire.difference(DateTime.now()),(){ Navigator.pop(context);});

    var W = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;

    var H = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

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
                            t.cancel();
                            for(var i in photos.where((e) => e!=null&& e["photo"]==null))
                              i["file"].delete();
                            Navigator.pop(context);
                          },
                        )),
                    Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            child: Column(
                              children: [
                                WaapButton(
                                  Text(
                                    "send".tr().toUpperCase(),
                                    style: STYLES.text["title"],
                                  ),
                                  type: WaapButton.BOTH,
                                  callback: () {
                                    sendPhotos();
                                  },
                                ),
                                Container( width: 30, height: 30, margin: EdgeInsets.only(top: 10),
                                  child: SENDING ? Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: STYLES.palette["primary"],
                                      strokeWidth: 4,
                                    ),
                                  ): null,
                                )
                              ],
                            ),
                          ),
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
                                          child: Text(widget.challenge.theme,
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
                                          child: Text(widget.challenge.reward,
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
                                      widget.challenge.users
                                          .map((e) => Container(
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
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Row(
                                        children: photos
                                            .map((e) => Container(
                                                  margin: EdgeInsets.only(
                                                      left: squareSpace / 4),
                                                  child: e == null
                                                      ? Container()
                                                      : GestureDetector(
                                                          onTap: () async {
                                                            await Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => PhotoviewPage(
                                                                        photos,
                                                                        photos.indexOf(
                                                                            e), Challenge.STARTED, widget.challenge.id)));
                                                            setState(() {
                                                              photos.sort((a,b) => (a==null && b!=null)? 1 : -1);
                                                            });
                                                          },
                                                          child: Container(
                                                            child: Stack(
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
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  child: (e["photo"] !=
                                                                          null)
                                                                      ? Container(
                                                                          color:
                                                                              STYLES.palette["primary"],
                                                                          child:
                                                                              Icon(
                                                                            Icons.check,
                                                                            size:
                                                                                20,
                                                                            color:
                                                                                STYLES.palette["accent"],
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
                                                          color: Colors.white,
                                                          width: borderSize)),
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                    Expanded(
                                      child: (photos
                                                  .where((e) => e == null)
                                                  .length >
                                              0)
                                          ? GestureDetector(
                                              onTap: getImage,
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 15),
                                                      child: Text(
                                                          photos
                                                              .where((e) =>
                                                                  e == null)
                                                              .length
                                                              .toString(),
                                                          style: STYLES.text[
                                                              "optionTitle"]),
                                                    ),
                                                    Icon(
                                                      Icons.camera_alt_outlined,
                                                      size: 30,
                                                    ),
                                                    Text(
                                                      "press_to_take".tr(),
                                                      style:
                                                          STYLES.text["base"],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ),
                                  ],
                                );
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
