import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waap/models/Challenge.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static int NMax = 5;

  static init() async {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings();
    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    if (Platform.isIOS) {
      final bool result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    tz.initializeTimeZones();
  }

  static showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  static sheduledNotification(
      {int duration, int id, String title, String body}) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(Duration(seconds: duration)),
        const NotificationDetails(
            android: AndroidNotificationDetails('your channel id',
                'your channel name', 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  static sheduledFromList(List<Challenge> challenges) async {
    // List notifications = await getNotifications();
    // List titles = notifications.map((e) => e.title).toList();

    await clear();
    List soon = [];
    for (var c in challenges) {
      if (c.status == Challenge.STARTED) {
        soon.add([
          c.theme,
          c.voting
              .difference(DateTime.now())
              .inSeconds
              .toInt(),
          Challenge.VOTING
        ]);
        soon.add([
          c.theme,
          c.expire
              .difference(DateTime.now())
              .inSeconds
              .toInt(),
          Challenge.STARTED
        ]);
      } else if (c.status == Challenge.VOTING) {
        soon.add([
          c.theme,
          c.voting
              .difference(DateTime.now())
              .inSeconds
              .toInt(),
          Challenge.VOTING
        ]);
      }
    }
    soon.sort((a, b) => a[1] < b[1] ? -1 : 1);
    soon = soon.take(NMax).toList();

    for (var i = 0; i < soon.length; i++) {
      sheduledNotification(
          id: i,
          duration: soon[i][1],
          title: soon[i][0],
          body: soon[i][2] == Challenge.STARTED
              ? "voting_started".tr()
              : "voting_finished".tr());
    }
    // var p = await getNotifications();
    // print(p
    //     .map((e) => e.id.toString() + e.title + e.payload)
    //     .toList());
  }

  static clear() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static getNotifications() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
    await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotificationRequests;
  }
}
