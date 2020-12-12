
import 'package:flutter/material.dart';
import 'package:waap/STYLES.dart';

class WaapButton extends StatelessWidget {
  WaapButton(this.child, {this.type = 2, this.callback });

  VoidCallback callback;
  static double bordersize=2;

  Widget child;
  int type;
  static const int LEFT = 0;
  static const int RIGHT = 1;
  static const int BOTH = 2;

  Map _TYPE = {
    0: EdgeInsets.only(left: bordersize, top: bordersize, bottom: bordersize),
    1: EdgeInsets.only(right: bordersize, top: bordersize, bottom: bordersize),
    2: EdgeInsets.symmetric(horizontal: bordersize, vertical: bordersize),
  };
  Map _TYPE2 = {
    0: BorderRadius.horizontal(left: Radius.circular(1000)),
    1: BorderRadius.horizontal(right: Radius.circular(1000)),
    2: BorderRadius.all(Radius.circular(1000)),
  };

  @override
  Widget build(BuildContext context) {
    return Container( padding: _TYPE[type],
      decoration: BoxDecoration(color: STYLES.palette["border"],
           borderRadius: _TYPE2[type]),
      child : GestureDetector(
        child: Container( padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          decoration: BoxDecoration(color: STYLES.palette["primary"],
              borderRadius: _TYPE2[type]),
          child: child,
    ),
        onTap: callback,
      ),
    );
  }
}
