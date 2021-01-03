import 'package:flutter/material.dart';
import 'package:waap/STYLES.dart';
import 'package:waap/services/api.dart';

class FriendSearchItem extends StatefulWidget {
  FriendSearchItem({this.requests, this.username}){print(requests);print(username);}


  List<String> requests;

  String username;

  @override
  _FriendSearchItemState createState() => _FriendSearchItemState();
}

class _FriendSearchItemState extends State<FriendSearchItem> {
  int status;
  static const int ADD = 0;
  static const int REFUSE = 1;
  static const int WAITING = 2;

  static double borderWidth = 2;

  @override
  void initState() {
    status = (widget.requests.contains(widget.username)) ? REFUSE : ADD;
  }


  @override
  void didUpdateWidget(FriendSearchItem oldWidget) {
    setState(() {
      status = (widget.requests.contains(widget.username)) ? REFUSE : ADD;
    });
  }

  getIcon() {
    switch (status) {
      case ADD:
        return GestureDetector(
            child: Icon(
              Icons.add,
              color: Colors.grey,
            ),
            onTap: () async {
              try {
                await API.addFriend(widget.username);
                widget.requests.add(widget.username);
                setState(() {
                  status = REFUSE;
                });
              } catch (e) {}
            });
      case REFUSE:
        return GestureDetector(
            child: Icon(
              Icons.close,
              color: Colors.red,
            ),
            onTap: () async {
              try {
                await API.deleteFriend(widget.username);
                widget.requests.remove(widget.username);
                setState(() {
                  status = ADD;
                });
              } catch (e) {}
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
          )
        ],
      ),
    );
  }
}
