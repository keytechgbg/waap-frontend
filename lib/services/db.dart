import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:waap/models/Challenge.dart';
import 'package:waap/models/Friend.dart';
import 'package:waap/models/Photo.dart';

class DBHelper {
  static Database _db;

  static String _photoDir;

  static getDir() async {
    _photoDir = _photoDir ??
        (await getApplicationDocumentsDirectory()).path + "/photos/";
    return _photoDir;
  }

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = documentDirectory.path + 'waap.db';
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    await getDir();
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
      ..execute(
          'CREATE TABLE friends (id INTEGER PRIMARY KEY, username TEXT UNIQUE, status INTEGER, from_user INTEGER)')
      ..execute(
          'CREATE TABLE challenges (id INTEGER PRIMARY KEY, users TEXT, status INTEGER,  image_count INTEGER, expire INTEGER, voting INTEGER, theme TEXT, reward TEXT, winners TEXT)')
      ..execute(
          'CREATE TABLE photos (id INTEGER PRIMARY KEY,  url TEXT, owner TEXT, likes INTEGER DEFAULT 0,  liked INTEGER DEFAULT 0, challenge_id INTEGER)');

  }

  Future<Friend> addFriend(Friend friend) async {
    var dbClient = await db;
    friend.id = await dbClient.insert('friends', friend.toMap());
    return friend;
  }

  Future<List<Friend>> getFriends() async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .query('friends', columns: ['id', 'username', 'status', 'from_user']);
    List<Friend> friends = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        friends.add(Friend.fromMap(maps[i]));
      }
    }
    return friends;
  }

  Future<int> deleteFriend(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'friends',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateFriend(Friend friend) async {
    var dbClient = await db;
    return await dbClient.update(
      'friends',
      friend.toMap(),
      where: 'id = ?',
      whereArgs: [friend.id],
    );
  }

  Future<int> updateFriendsFromList(List list) async {
    list = list.map((e) {
      e["status"] = Friend.STATUSES[e["status"]];
      return e;
    }).toList();

    var dbClient = await db;
    List<Map> maps = await dbClient
        .query('friends', columns: ['id', 'username', 'status', 'from_user']);

    for (var i in maps) {
      if (!list.map((e) => e["username"]).contains(i["username"])) {
        await deleteFriend(i["id"]);
        maps.remove(i);
      }
    }

    check(Map item) {
      for (var i in maps) {
        if (i["username"] == item["username"]) {
          return i;
        }
      }
      return null;
    }

    for (var f in list) {
      var c = check(f);
      if (c != null) {
        if (c["status"] != f["status"]) {
          await dbClient.update(
            'friends',
            f,
            where: 'id = ?',
            whereArgs: [c["id"]],
          );
        }
        continue;
      } else
        dbClient.insert("friends", f);
    }

    return 1;
  }

  Future<int> updateChallenge(Challenge challenge) async {
    var dbClient = await db;
    return await dbClient.update(
      'challenges',
      challenge.toMap(),
      where: 'id = ?',
      whereArgs: [challenge.id],
    );
  }

  Future<List<Challenge>> getChallenges() async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .query('challenges', columns: ['id' , 'users' , 'status' ,  'image_count' , 'expire' , 'voting' , 'theme' , 'reward', 'winners']);
    List<Challenge> challenges = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        challenges.add(Challenge.fromMap(maps[i]));
      }
    }
    return challenges;
  }

  Future<int> deleteChallenge(int id)async{
    var dbClient = await db;

    return await dbClient.delete(
      'challenges',
      where: 'id = ?',
      whereArgs: [id],
    );

  }

  Future<int> updateChallengesFromList(List list) async {
    list = list.map((e) {
      e["status"] = Challenge.STATUSES[e["status"]];
      e["users"] = e["users"].join(" ");
      return e;
    }).toList();

    var dbClient = await db;
    List<Map> maps = await dbClient
        .query('challenges', columns: ['id' , 'users' , 'status' ,  'image_count' , 'expire' , 'voting' , 'theme' , 'reward']);

    for (var i in maps) {
      if (!list.map((e) => e["id"]).contains(i["id"])) {
        await dbClient.delete(
          'challenges',
          where: 'id = ?',
          whereArgs: [i["id"]],
        );
        maps.remove(i);
      }
    }

    check(Map item) {
      for (var i in maps) {
        if (i["id"] == item["id"]) {
          return i;
        }
      }
      return null;
    }

    for (var f in list) {
      var c = check(f);
      if (c != null) {
          await dbClient.update(
            'challenges',
            f,
            where: 'id = ?',
            whereArgs: [c["id"]],
          );
      } else
        dbClient.insert("challenges", f);
    }

    return 1;
  }

  Future<List<Photo>> getPhotos(int challenge_id) async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .query('photos', columns: ['id', 'url', 'owner', 'likes', 'liked', 'challenge_id'], where: 'challenge_id = ?',
      whereArgs: [challenge_id],);
    List<Photo> photos = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        photos.add(Photo.fromMap(maps[i]));
      }
    }
    return photos;
  }

  Future<int> updatePhotosFromList(List list, int challenge_id) async {

    list = list.map((e) {
      e["challenge_id"] = challenge_id;
      return e;
    }).toList();


    var dbClient = await db;
    List<Map> maps = await dbClient
        .query('photos', columns: ['id', 'url', 'owner', 'likes', 'liked', 'challenge_id'], where: 'challenge_id = ?',
      whereArgs: [challenge_id], );

    for (var i in maps) {
      if (!list.map((e) => e["url"]).contains(i["url"])) {
        await dbClient.delete(
          'photos',
          where: 'id = ?',
          whereArgs: [i["id"]],
        );
        try{
          String path = _photoDir+challenge_id.toString()+"/"+ i["url"].split("/").last;
          File file= File(path);
          await file.delete();
        }catch(e){print(e);}
        maps.remove(i);
      }
    }

    check(Map item) {
      for (var i in maps) {
        if (i["url"] == item["url"]) {
          return i;
        }
      }
      return null;
    }

    for (var p in list) {
      var c = check(p);
      if (c != null) {
        if (c["likes"] != p["likes"] || c["liked"] != p["liked"] ) {
          await dbClient.update(
            'photos',
            p,
            where: 'id = ?',
            whereArgs: [c["id"]],
          );
        }
        continue;
      } else
        dbClient.insert("photos", p);
    }

    return 1;
  }

  Future clear() async{
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      var batch = txn.batch();
      batch.delete("friends");
      batch.delete("challenges");
      batch.delete("photos");
      await batch.commit();
    });

  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
