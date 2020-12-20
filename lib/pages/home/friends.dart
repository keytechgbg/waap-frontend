import 'dart:io';
import 'package:flutter/material.dart';
import 'package:waap/STYLES.dart';
import 'package:waap/components/FriendListItem.dart';
import 'package:waap/components/WaapButton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waap/models/Friend.dart';
import 'package:waap/pages/home/friend_search.dart';
import 'package:waap/services/api.dart';
import 'package:waap/services/db.dart';

class FriendsPage extends StatefulWidget {
  FriendsPage(this.usersInChallenge);

  List<String> usersInChallenge = [];

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List<String> friends;

  List<String> friendshipRequests;

  final double borderSize = 2;

  var t = 0;

  getFriends() async {
    var db = DBHelper();
    var response = await API.getFriends();
    if (response is List) {
      await db.updateFriendsFromList(response);
    }
    var flist = await db.getFriends();
    friends = flist
        .where((e) => e.status == Friend.ACCEPTED)
        .map((e) => e.username)
        .toList()
        .cast<String>();
    friendshipRequests = flist
        .where((e) => e.from_user == 1 && e.status != Friend.ACCEPTED)
        .map((e) => e.username)
        .toList()
        .cast<String>();
    return 1;
  }

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
                          Navigator.pop(context, widget.usersInChallenge);
                        },
                      )),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "friends".tr(),
                        style: STYLES.text["pageTitle"],
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: WaapButton(
                        Icon(Icons.group_add),
                        type: WaapButton.LEFT,
                        callback: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FriendSearchPage(friendshipRequests)));
                        },
                      )),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<Object>(
                  future: getFriends(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        height: double.infinity,
                        padding: EdgeInsets.only(top: 50)
                            .add(EdgeInsets.symmetric(horizontal: 10)),
                        child: ListView(
                          children: friends
                              .map((e) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: FriendListItem(
                                      friends: widget.usersInChallenge,
                                      username: e,
                                      callback: (){setState(() {

                                      });},
                                    ),
                                  ))
                              .toList(),
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
                  }),
            )
          ],
        ),
      ),
    );
  }
}
