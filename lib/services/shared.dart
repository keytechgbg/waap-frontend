import 'package:shared_preferences/shared_preferences.dart';

class Shared{

  static Future<bool> isAuthenticated() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var logedin = prefs.getBool("logedin");

    if (logedin==null){
      await prefs.setBool("logedin", false);
      logedin=false;
    }
    return logedin;
  }



}