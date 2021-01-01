import 'dart:io';

import 'package:flutter/material.dart';

import 'package:waap/STYLES.dart';
import 'package:waap/components/WaapButton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waap/components/custom_icons_icons.dart';
import 'package:waap/models/Challenge.dart';
import 'package:waap/models/Photo.dart';
import 'package:waap/services/api.dart';
import 'package:waap/services/shared.dart';

class PhotoviewPage extends StatefulWidget {
  List photos;

  List allphotos;
  int mode;
  int challenge_id;
  int initial;

  PageController _controller;

  PhotoviewPage(this.allphotos, this.initial, this.mode, this.challenge_id) {
    photos = allphotos.where((p) => p != null).toList();
    _controller = PageController(
      viewportFraction: 1,
      initialPage: initial,
    );
  }

  @override
  _PhotoviewPageState createState() => _PhotoviewPageState();
}

class _PhotoviewPageState extends State<PhotoviewPage> {


  sendLike(p)async{
    parentShouldRebuild=true;
    Photo photo = p["photo"];
    var response= photo.liked == 0 ? await API.addLike(widget.challenge_id, photo.url): await API.deleteLike(widget.challenge_id, photo.url);

    if(response is Map && response.containsKey("success")){
      photo.likes+= photo.liked==0 ? 1: -1;
      photo.liked=(photo.liked+1)%2;

      var i = widget.allphotos.indexOf(p);
      widget.allphotos[i]["photo"].likes=photo.likes;
      widget.allphotos[i]["photo"].liked=photo.liked;
      setState(() {

      });
    }


  }

  void updateLike( page ){ setState(() {
    currentPhoto=widget.photos[page];
  });}

  var currentPhoto;

  @override
  void initState() {
    super.initState();
    currentPhoto=widget.photos[widget.initial];
  }
  final double borderSize = 2;

  bool back = false;

  Widget backImage;


  bool parentShouldRebuild=false;
  @override
  Widget build(BuildContext context) {
    var W = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;

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
                          setState(() {
                            back = true;
                            var p =
                                widget.photos[widget._controller.page.toInt()];
                            backImage = KeepAlivePage(
                              child: Hero(
                                  tag: p["file"].path,
                                  child: Image.file(
                                    p["file"],
                                    gaplessPlayback: true,
                                    fit: BoxFit.contain,
                                  )),
                            );
                          });
                          Navigator.pop(context, parentShouldRebuild);
                        },
                      )),
                  Align(
                      alignment: Alignment.topRight,
                      child: widget.mode == Challenge.STARTED
                          ? WaapButton(
                              Icon(Icons.delete),
                              type: WaapButton.LEFT,
                              callback: () async {
                                var p = widget
                                    .photos[widget._controller.page.toInt()];

                                if (p["photo"] != null) {
                                  var resp = await API.deletePhoto(
                                      widget.challenge_id, p["photo"].url);

                                  if (!(resp is Map &&
                                      resp.containsKey("success"))) return 0;
                                }
                                widget.allphotos[widget.allphotos.indexOf(p)] =
                                    null;
                                p["file"].delete();
                                p = null;
                                widget.photos
                                    .removeAt(widget._controller.page.toInt());
                                setState(() {});
                                if (widget.photos.isEmpty)
                                  Navigator.pop(context);
                              },
                            )
                          : Container()),
                ],
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(top: 0),
              color: Colors.black,
              child: !back
                  ? GestureDetector(
                 onDoubleTap: () {
                   if (widget.mode==Challenge.FINISHED)
                     return 0;
                   sendLike(currentPhoto);
                 },
                    child: Stack(
                      children: [
                        PageView(
                          onPageChanged: updateLike,
                            controller: widget._controller,
                            children: widget.photos
                                .map(
                                  (e) => KeepAlivePage(
                                    child: Hero(
                                        tag: e["file"].path,
                                        child: Image.file(
                                          e["file"],
                                          gaplessPlayback: true,
                                          fit: BoxFit.contain,
                                        )),
                                  ),
                                )
                                .toList(),
                          ),
                        widget.mode != Challenge.STARTED ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                            color: Color(0xAA000000),
                            child: Row(mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  currentPhoto["photo"].likes.toString(),
                                  style: STYLES.text["title"],
                                ),
                                Icon(currentPhoto["photo"].liked == 1
                                    ? CustomIcons.heart
                                    : CustomIcons.heart_empty)
                              ],
                            ),
                          ),
                        ): Container()
                      ],
                    ),
                  )
                  : backImage,
            ))
          ],
        ),
      ),
    );
  }
}

class KeepAlivePage extends StatefulWidget {
  KeepAlivePage({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _KeepAlivePageState createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    /// Dont't forget this
    super.build(context);

    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
