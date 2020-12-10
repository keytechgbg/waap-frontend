import 'package:flutter/material.dart';
import 'package:waap/STYLES.dart';
import 'package:easy_localization/easy_localization.dart';


class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Error", style: STYLES.text["error"]));
  }
}
