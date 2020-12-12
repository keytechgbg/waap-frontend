import 'package:dio/dio.dart';
import 'dart:convert';
import 'shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';

class API {
  static String _token;
  static const String _baseURL = "http://192.168.31.29:8080/api/";
  static var dio ;

  static _getToken () async{
    if (_token==null)  _token= await Shared.getToken();
    return _token;
  }

  static init() {
    dio = dio?? Dio(BaseOptions(
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
        }
      else
        data = {"non_field_errors": e};
      }catch(e){data = {"non_field_errors": "network_connection_error".tr()};}
      return data;
    }
    data = response.data;
    return data;
  }

  static register({@required String username, @required String password, @required String email}) async {
    var data;
    var response;
    init();
    try {
      response = await dio
          .post("registration/", data: {"username": username, "password": password, "email": email});
    } catch (e) {
      try {
        if (e.response.statusCode == 400) {
          data = e.response.data;
        }
        else
          data = {"non_field_errors": e};
      }catch(e){data = {"non_field_errors": "network_connection_error".tr()};}
      return data;
    }
    data = response.data;
    return data;
  }

}
