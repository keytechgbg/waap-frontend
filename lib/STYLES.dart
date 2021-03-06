import 'package:flutter/material.dart';

class STYLES {

  static double width=400;

  static InputDecoration loginFormText = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    contentPadding: new EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
    border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 2)),
  );

  static InputDecoration optionsTextField = InputDecoration(
    contentPadding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
    focusedBorder:OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2)),
    border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF4C540B) , width: 2)),
  );
  static var buttonTopPadding = EdgeInsets.only(top: 30);

  static Map get text => {
    "mainTitle": TextStyle(
        color: theme["textColor"], fontSize: width*0.1, fontWeight: FontWeight.w600),
    "pageTitle": TextStyle(
        color: theme["textColor"], fontSize: width*0.06, fontWeight: FontWeight.w600),
    "title": TextStyle(
        color: theme["textColor"], fontSize: width*0.05, fontWeight: FontWeight.w600),
    "optionTitle": TextStyle(
        color: theme["textColor"], fontSize: width*0.045, fontWeight: FontWeight.w600),
    "base": TextStyle(color: theme["textColor"], fontSize: width*0.035, fontWeight: FontWeight.w600),
    "optionTextField": TextStyle(  decoration:  TextDecoration.none,
        color: theme["textColor"], fontSize: width*0.045, fontWeight: FontWeight.w500),
    "error": TextStyle(color: theme["error"], fontSize: width*0.025),
    "imageCount": TextStyle(
        color: theme["textColor"], fontSize: width*0.08, fontWeight: FontWeight.w600),
    "button1": TextStyle(
        color: theme["textColor"], fontSize: width*0.06, fontWeight: FontWeight.w600),
    "button2": TextStyle(
        color: theme["textColor"], fontSize: width*0.035, fontWeight: FontWeight.w600),
  };

  static double get  buttonhpadding => width * 0.06;
  static double get  usualpadding => width * 0.025;

  static Map theme = palette;

  static ThemeData get main_theme => ThemeData(

      scaffoldBackgroundColor: Color(0xFF4C540B),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: Color(0xFF8E9B17),
      backgroundColor: Color(0xFF4C540B),
      accentColor: Colors.white,
      fontFamily: "Montserrat",
      iconTheme: IconThemeData(color: Colors.white, size: width*0.1),
      buttonTheme: ButtonThemeData(
        disabledColor: Color(0xFF626A10),
        buttonColor: Color(0xFF8E9B17),
        textTheme: ButtonTextTheme.accent,
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 8,
        ),
      ));

  static var palette = {
    "background": Color(0xFF4C540B),
    "notifBar": Color(0xFF145DA0),
    "primary": Color(0xFF8E9B17),
    "accent": Color(0xFFFFFFFF),
    "textColor": Color(0xFFFFFFFF),
    "error": Colors.red,
    "border": Color(0xFFFFFFFF),
    "voting": Color(0xFFB299E5)
  };
}
