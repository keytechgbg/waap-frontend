import 'package:flutter/material.dart';
import 'package:waap/STYLES.dart';
import 'package:waap/components/DeleteFriendDialog.dart';
import 'package:waap/services/api.dart';

class FriendListItem extends StatefulWidget {
  FriendListItem({this.friends, this.username, this.callback});

  Function callback;

  List<String> friends;

  String username;

  @override
  _FriendListItemState createState() => _FriendListItemState();
}

class _FriendListItemState extends State<FriendListItem> {
  int status;
  static const int ADD = 0;
  static const int DONE = 1;

  static double borderWidth = 2;

  @override
  void initState() {
    status = (widget.friends.contains(widget.username)) ? DONE : ADD;
  }

  getIcon() {
    switch (status) {
      case ADD:
        return GestureDetector(
            child: Icon(
              Icons.add,
              color: Colors.grey,
            ),
            onTap: () {
              widget.friends.add(widget.username);
              setState(() {
                status = DONE;
              });
            });
      case DONE:
        return GestureDetector(
            child: Icon(
              Icons.check,
              color: STYLES.palette["primary"],
            ),
            onTap: () {
              widget.friends.remove(widget.username);
              setState(() {
                status = ADD;
              });
            });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border.all(color: STYLES.palette["primary"], width: borderWidth)),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          getIcon(),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              widget.username,
              style: STYLES.text["base"].copyWith(color: Colors.black),
            ),
          ),
          Flexible(child: Container(), ),
          GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: () async{
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) =>
                        DeleteFriendDialog(widget.username, widget.callback));
                if (status==DONE){
                  widget.friends.remove(widget.username);
                }
              })
        ],
      ),
    );
  }
}
