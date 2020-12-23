import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:waap/models/Challenge.dart';
import 'package:waap/models/Friend.dart';

class DBHelper {
  static Database _db;

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
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
      ..execute(
          'CREATE TABLE friends (id INTEGER PRIMARY KEY, username TEXT UNIQUE, status INTEGER, from_user INTEGER)')
      ..execute(
          'CREATE TABLE challenges (id INTEGER PRIMARY KEY, users TEXT, status INTEGER,  image_count INTEGER, expire INTEGER, voting INTEGER, theme TEXT, reward TEXT)');
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

  Future<List<Challenge>> getChallenges() async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .query('challenges', columns: ['id' , 'users' , 'status' ,  'image_count' , 'expire' , 'voting' , 'theme' , 'reward']);
    List<Challenge> challenges = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        challenges.add(Challenge.fromMap(maps[i]));
      }
    }
    return challenges;
  }

  Future<int> updateChallengesFromList(List list) async {
    list = list.map((e) {
      e["status"] = Challenge.STATUSES[e["status"]];
      var expire=e["expire"].toInt();
      e["expire"] = DateTime.now().add(Duration(seconds : expire)).millisecondsSinceEpoch;
      e["voting"] = DateTime.now().add(Duration(seconds : e["voting"].toInt()+expire)).millisecondsSinceEpoch;
      e["users"] = e["users"].join(" ");
      return e;
    }).toList();

    var dbClient = await db;
    List<Map> maps = await dbClient
        .query('challenges', columns: ['id' , 'users' , 'status' ,  'image_count' , 'expire' , 'voting' , 'theme' , 'reward' ]);

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

  Future clear() async{
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      var batch = txn.batch();
      batch.delete("friends");
      batch.delete("challenges");
      await batch.commit();
    });

  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
