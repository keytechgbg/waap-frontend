import 'dart:io';

import 'package:dio/dio.dart';
import 'shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:path_provider/path_provider.dart';

class API {
  static String _token;
  static const String _baseURL = "https://waap-test.herokuapp.com/api/";
  static var dio;
  static String photoDir;

  static close(){
    _token=null;
  }

  static _getToken() async {
    if (_token == null) _token = await Shared.getToken();
    return _token;
  }

  static init() async{
    dio = dio ??
        Dio(BaseOptions(
          // connectTimeout: 5000,
          baseUrl: _baseURL,
        ));

    photoDir=photoDir ?? (await getApplicationDocumentsDirectory()).path+"/photos/";
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
        print(e);
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
      try{print(e);
        if (e.response.statusCode == 400) {
          return [];
        } else
          return null;
      }catch(e){
        return null;}
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

  static updateFriend(String username, String status) async {
    var data;
    var response;
    init();
    try {
      response = await dio.put("friends/",
          options: Options(headers: {"Authorization": await _getToken()}),
          data: {"to_user": username, "status": status});
    } catch (e) {
      return{};
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

  static getChallenges() async {
    var data;
    var response;
    init();

    try {
      response = await dio.get("challenges/",
          options: Options(headers: {"Authorization": await _getToken()}));
    } catch (e) {
      try{

        if (e.response.statusCode == 400) {
          return {"error":e};
        } else
          return null;
      }catch(e){return null;}
    }

    data = response.data;
    return data;
  }

  static addChallenge(String users, int image_count, int expire, int voting, String theme, String reward) async {
    var data;
    var response;
    init();
    try {
      response = await dio.post("challenges/",
          options: Options(headers: {"Authorization": await _getToken()}),
          data: {"users": users, "image_count": image_count, "expire": expire, "voting": voting , "theme": theme, "reward": reward});
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

  static deleteChallenge(int challenge_id) async {
    var data;
    var response;
    init();
    try {
      response = await dio.delete("challenges/",
          options: Options(headers: {"Authorization": await _getToken()}),
          data: {"id": challenge_id});
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

  static getPhotos(int challenge_id) async {
    var data;
    var response;
    init();

    try {
      response = await dio.get("photos/",
          options: Options(headers: {"Authorization": await _getToken()}), queryParameters: {"challenge_id": challenge_id});
    } catch (e) {
      try{

        if (e.response.statusCode == 400) {
          return {"error":e};
        } else
          return null;
      }catch(e){

        return null;}
    }

    data = response.data;
    return data;
  }

  static addPhoto(int challenge_id, File photo) async {
    var data;
    var response;
    init();
    try {
      FormData formData = FormData.fromMap({"photo": await MultipartFile.fromFile(photo.path )});
      response = await dio.post("photos/",
          options: Options(headers: {"Authorization": await _getToken()}),
          data: formData, queryParameters: {"challenge_id": challenge_id});
    } catch (e) {
      try{print(e);
        if (e.response.statusCode == 400) {
          return {"error":e};
        } else
          return null;
      }catch(e){return null;}
    }
    data = response.data;
    return data;
  }

  static deletePhoto(int challenge_id, String url) async {
    var data;
    var response;
    init();
    try {
      response = await dio.delete("photos/",
          options: Options(headers: {"Authorization": await _getToken()}),
          data: {"url": url}, queryParameters: {"challenge_id": challenge_id});
    } catch (e) {
      try{
        if (e.response.statusCode == 400) {
          return {"error":e};
        } else
          return null;
      }catch(e){return null;}
    }
    data = response.data;
    return data;
  }

  static getLikes(int challenge_id) async {
    var data;
    var response;
    init();

    try {
      response = await dio.get("likes/",
          options: Options(headers: {"Authorization": await _getToken()}), queryParameters: {"challenge_id": challenge_id});
    } catch (e) {
      try{
        print(e);
        if (e.response.statusCode == 400) {
          return {"error":e};
        } else
          return null;
      }catch(e){

        return null;}
    }

    data = response.data;
    return data;
  }

  static addLike(int challenge_id, String url) async {
    var data;
    var response;
    init();
    try {
      response = await dio.post("likes/",
        options: Options(headers: {"Authorization": await _getToken()}),
        data: {"url": url}, queryParameters: {"challenge_id": challenge_id});
    } catch (e) {
      try{
        if (e.response.statusCode == 400) {
          return {"error":e};
        } else
          return null;
      }catch(e){return null;}
    }
    data = response.data;
    return data;
  }

  static deleteLike(int challenge_id, String url) async {
    var data;
    var response;
    init();
    try {
      response = await dio.delete("likes/",
          options: Options(headers: {"Authorization": await _getToken()}),
          data: {"url": url}, queryParameters: {"challenge_id": challenge_id});
    } catch (e) {
      try{
        if (e.response.statusCode == 400) {
          return {"error":e};
        } else
          return null;
      }catch(e){return null;}
    }
    data = response.data;
    return data;
  }

  static getStats() async {
    var data;
    var response;
    init();

    try {
      response = await dio.get("statistics/",
          options: Options(headers: {"Authorization": await _getToken()}));
    } catch (e) {
        return null;
    }

    data = response.data;
    return data;
  }

  static changePassword({String old_password, String new_password})async{
    var data;
    var response;
    init();
    try {
      response = await dio
          .post("changepass/", options: Options(headers: {"Authorization": await _getToken()}), data: {"old_password": old_password, "new_password": new_password});
    } catch (e) {
      try {
        print(e);
        if (e.response.statusCode == 400) {
          data = e.response.data;

        } else
          data = {"non_field_errors": e.toString()};
      } catch (e) {
        data = {"non_field_errors": "network_connection_error".tr()};
      }
      return data;
    }
    data = response.data;
    return data;

  }


  static sendProposal(String message)async{
    var data;
    var response;
    init();
    try {
      response = await dio
          .post("proposals/", options: Options(headers: {"Authorization": await _getToken()}), data: {"message":message});
    } catch (e) {
      try {
        if (e.response.statusCode == 400) {
          data = e.response.data;

        } else
          data = {"non_field_errors": e.toString()};
      } catch (e) {
        data = {"non_field_errors": "network_connection_error".tr()};
      }
      return data;
    }
    data = response.data;
    return data;

  }

  static getProposals() async {
    var data;
    var response;
    init();

    try {
      response = await dio.get("proposals/",
          options: Options(headers: {"Authorization": await _getToken()}));
    } catch (e) {
      return null;
    }

    data = response.data;
    return data;
  }

  static reportProblem(String message)async{
    var data;
    var response;
    init();
    try {
      response = await dio
          .post("problems/", options: Options(headers: {"Authorization": await _getToken()}), data: {"message":message});
    } catch (e) {
      try {
        if (e.response.statusCode == 400) {
          data = e.response.data;

        } else
          data = {"non_field_errors": e.toString()};
      } catch (e) {
        data = {"non_field_errors": "network_connection_error".tr()};
      }
      return data;
    }
    data = response.data;
    return data;

  }

  static downloadPhoto(int challenge_id, String url) async{

    String path = photoDir+challenge_id.toString()+"/"+ url.split("/").last;
    try{
      await Dio().download(url, path, onReceiveProgress: (received, total) {
        int percentage = ((received / total) * 100).floor();
        print(percentage);
      });
    }catch(e){
      try{
        File file= File(path);
        await file.delete();
      }catch(e){print(e);}
    }
    return await getDownloadedPhoto(challenge_id, url);

  }

  static getDownloadedPhoto(int challenge_id, String url)async{

    String path = photoDir+challenge_id.toString()+"/"+ url.split("/").last;
    File file= File(path);
    if (await file.exists()){
      return file;
    }else
      return null;
  }

}
