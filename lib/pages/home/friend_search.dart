import 'dart:async';

import 'package:flutter/material.dart';
import 'package:waap/STYLES.dart';
import 'package:waap/components/FriendSearchItem.dart';
import 'package:waap/components/WaapButton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waap/components/SafeScroll.dart';
import 'package:waap/services/api.dart';

class FriendSearchPage extends StatelessWidget {
  TextEditingController search = new TextEditingController();

  var input = new StreamController();

  Timer timer = Timer(Duration(seconds: 1), () {});

  List<String> requests;

  FriendSearchPage(this.requests);

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
                          Navigator.pop(context);
                        },
                      )),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "add_friends".tr(),
                        style: STYLES.text["pageTitle"],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 50),
              child: Container(color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row( mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search,color: Colors.grey[700],size: 30,),
                    Expanded(
                      child: TextField(
                        cursorColor: STYLES.palette["primary"],
                        style: STYLES.text["base"].copyWith(color: Colors.black),
                        controller: search,
                        enableSuggestions: false,
                        enableInteractiveSelection: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,

                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: new EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),),
                        onChanged: (String text) async {
                          if (timer.isActive) {
                            timer.cancel();
                          }

                          text = text.split(" ").join("");
                          if (text.length > 0) {
                            timer = Timer(Duration(milliseconds: 500), () async {
                              input.add(await API.searchFriends(text));
                            });
                          }
                        },
                      ),
                    ),
                    GestureDetector(child: Icon(Icons.close,color: Colors.grey[700],size: 30,), onTap: search.clear,),
                  ],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: input.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        if (!snapshot.data.keys.contains("non_field_errors")) {
                          return Container(
                            height: double.infinity,
                            padding: EdgeInsets.only(top: 50).add(EdgeInsets.symmetric(horizontal: 10)),
                            child: ListView(
                              children: snapshot.data["results"]
                                  .map((e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: FriendSearchItem(
                                        requests: requests,
                                        username: e["username"],
                                      )))
                                  .toList()
                                  .cast<Widget>(),
                            ),
                          );
                        } else {
                          return Container(
                            alignment: Alignment.center,
                            child: Text(
                              "network_connection_error".tr(),
                              style: STYLES.text["error"],
                            ),
                          );
                        }
                      }
                      if (snapshot.hasError) {
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
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        child: Center(
                          child: Text("Your results will appear here"),
                        ),
                      );
                    }
                    return Container();
                  }),
            )
          ],
        ),
      ),
    );
  }
}
