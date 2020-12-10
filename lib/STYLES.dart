import 'package:flutter/material.dart';

class STYLES {
  static InputDecoration loginFormText = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    contentPadding: new EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2)),
  );
  static var buttonTopPadding= EdgeInsets.only(top: 30);
  static var text = {
    "pageTitle": TextStyle(
      color: theme["textColor"],
      fontSize: 30,
    ),
    "base": TextStyle(color: theme["textColor"], fontSize: 20),
    "error": TextStyle(color: theme["error"], fontSize: 20),
    "button1": TextStyle(
        color: theme["textColor"], fontSize: 25, fontFamily: "Montserrat", fontWeight: FontWeight.w600),

  };

  static Map theme = palette;

  static ThemeData main_theme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: Color(0xFF8E9B17),
    backgroundColor: Color(0xFF4C540B),
    accentColor: Colors.white,
    fontFamily: "Montserrat", iconTheme: IconThemeData(color: Colors.white, size: 30),
    buttonTheme: ButtonThemeData(buttonColor: Color(0xFF8E9B17), textTheme: ButtonTextTheme.accent, padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8,),  )
  );

  static var palette = {
    "background": Color(0xFF4C540B),
    "notifBar": Color(0xFF145DA0),
    "primary": Color(0xFF8E9B17),
    "accent": Color(0xFFFFFFFF),
    "textColor": Color(0xFFFFFFFF),
    "error": Colors.red,
    "border": Color(0xFFFFFFFF)
  };
}
