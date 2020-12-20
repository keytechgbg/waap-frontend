import 'dart:io';

import 'package:dio/dio.dart';
import 'dart:convert';
import 'shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';

class API {
  static String _token;
  static const String _baseURL = "http://192.168.31.29:8080/api/";
  static var dio;

  static _getToken() async {
    if (_token == null) _token = await Shared.getToken();
    return _token;
  }

  static init() {
    dio = dio ??
        Dio(BaseOptions(
          // connectTimeout: 5000,
          baseUrl: _baseURL,
        ));
  }

  static login({@required String username, @required String password}) async {
    var data;
    var response;
    init();
    try {
      response = await dio
          .post("login/", data: {"username": username, "password": password});
    } catch (e) {
      try {
        if (e.response.statusCode == 400) {
          data = e.response.data;
        } else
          data = {"non_field_errors": e};
      } catch (e) {
        data = {"non_field_errors": "network_connection_error".tr()};
      }
      return data;
    }
    data = response.data;
    return data;
  }

  static register(
      {@required String username,
      @required String password,
      @required String email}) async {
    var data;
    var response;
    init();
    try {
      response = await dio.post("registration/",
          data: {"username": username, "password": password, "email": email});
    } catch (e) {
      try {
        if (e.response.statusCode == 400) {
          data = e.response.data;
        } else
          data = {"non_field_errors": e};
      } catch (e) {
        data = {"non_field_errors": "network_connection_error".tr()};
      }
      return data;
    }
    data = response.data;
    return data;
  }

  static getFriends() async {
    var data;
    var response;
    init();
    try {
      response = await dio.get("friends/",
          options: Options(headers: {"Authorization": await _getToken()}));
    } catch (e) {
      print(e);
      if (e.response.statusCode == 400) {
        return [];
      } else
        return null;
    }

    data = response.data;
    return data;
  }

  static searchFriends(String search) async {
    var data;
    var response;
    init();
    try {
      response = await dio.get("search/",
          options: Options(headers: {"Authorization": await _getToken()}),
          queryParameters: {"search": search});
    } catch (e) {
      try {
        if (e.response.statusCode == 400) {
          data = e.response.data;
        } else
          data = {"non_field_errors": e};
      } catch (e) {
        data = {"non_field_errors": "network_connection_error".tr()};
      }
      return data;
    }
    data = response.data;
    return data;
  }

  static addFriend(String username) async {
    var data;
    var response;
    init();
    try {
      response = await dio.post("friends/",
          options: Options(headers: {"Authorization": await _getToken()}),
          data: {"to_user": username});
    } catch (e) {
      if (e.response.statusCode == 400) {
        data = e.response.data;
      } else
        data = {"non_field_errors": e};
      return data;
    }
    data = response.data;
    return data;
  }

  static deleteFriend(String username) async {
    var data;
    var response;
    init();
    try {
      response = await dio.delete("friends/",
          options: Options(headers: {"Authorization": await _getToken()}),
          data: {"to_user": username});
    } catch (e) {
      print(e);
      if (e.response.statusCode == 400) {
        data = e.response.data;
      } else
        data = {"non_field_errors": e};
      return data;
    }
    data = response.data;
    return data;
  }
}
