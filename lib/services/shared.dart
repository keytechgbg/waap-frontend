import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  static final stats = [
    "highest_rate",
    "won",
    "lost",
    "tied",
    "resigned"
  ];

  static Future<bool> isAuthenticated() async {
    var prefs = await SharedPreferences.getInstance();

    var logedin = prefs.getBool("logedin");
    if (logedin == null) {
      await prefs.setBool("logedin", false);
      logedin = false;
    }
    return logedin;
  }

  static logIn({@required String username, @required String token}) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool("logedin", true);
    _setUsername(username);
    _setToken(token);
  }

  static logOut() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.setBool("logedin", false);
  }

  static _initStats() async {
    var prefs = await SharedPreferences.getInstance();
    for (var x in stats) {
      prefs.setInt(x, 0);
    }
  }

  static Future<Map<String, int>> getStats() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getInt(stats[0]) == null) await _initStats();
    Map<String, int> res = {};
    for (var x in stats) {
      res[x] = prefs.getInt(x);
    }
    return res;
  }

  static Future setStats(Map statsMap) async {
    var prefs = await SharedPreferences.getInstance();
    for(var k in statsMap.keys){
      await prefs.setInt(k, statsMap[k]);
    }
  }



  static Future<String> getToken() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    return token;
  }

  static _setToken(String token) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  static Future<String> getUsername() async {
    var prefs = await SharedPreferences.getInstance();
    var uname = prefs.getString("username");
    return uname;
  }


  static _setUsername(String username) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("username", username);
  }
}
