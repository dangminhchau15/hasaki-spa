import 'dart:io';
import 'package:app/src/dataresources/remote/preference_provider.dart';
import 'package:app/src/dataresources/remote/share_preference_name.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessage extends StatefulWidget {
  @override
  _FirebaseMessageState createState() => _FirebaseMessageState();
}

class _FirebaseMessageState extends State<FirebaseMessage> {
  static FlutterLocalNotificationsPlugin _flutterNotificationPlugin;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String fcmToken;

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    _flutterNotificationPlugin = new FlutterLocalNotificationsPlugin();
    _flutterNotificationPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    //init firebase messaging
    _firebaseMessaging.configure(
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _showNotificationWithDefaultSound(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        onSelectNotification("");
      },
      onResume: (Map<String, dynamic> message) async {
        onSelectNotification("");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) async {
      await PreferenceProvider.load();
      print("fcm: $token");
      PreferenceProvider.setString(SharePrefNames.FCM_TOKEN, token);
    });
  }

  Future onSelectNotification(String payload) async {
    //Scaffold.of(context).showSnackBar(SnackBar(content: Text("Hello")));
  }

  static Future _showNotificationWithDefaultSound(
      Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    String title;
    String body;
    if (Platform.isIOS) {
      title = message['notification']['title'];
      body = message['notification']['body'];
    } else {
      title = message['data']['title'];
      body = message['data']['body'];
    }
    await _flutterNotificationPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: "payload",
    );
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      _showNotificationWithDefaultSound(data);
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      _showNotificationWithDefaultSound(notification);
    }

    // Or do other work.
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
