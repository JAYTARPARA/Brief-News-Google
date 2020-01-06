import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:google_news/src/ui/home/home_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    initOneSignal();
    // showRate();
  }

  void initOneSignal() {
    OneSignal.shared.init("7f1483d5-519c-4389-9808-cafa8d99a89d");

    OneSignal.shared.setNotificationReceivedHandler((OSNotification notification) {
      // will be called whenever a notification is received
    });

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // will be called whenever a notification is opened/button pressed.
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });

    OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // will be called whenever the subscription changes
      //(ie. user gets registered with OneSignal and gets a user ID)
    });

    OneSignal.shared.setEmailSubscriptionObserver((OSEmailSubscriptionStateChanges emailChanges) {
      // will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-4800441463353851~6558594714')
        .then((response) {
      myBanner
        ..load()
        ..show(
          // Banner Position
          anchorType: AnchorType.bottom,
        );
    });

    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-4800441463353851~6558594714')
        .then((response) {
      Timer.periodic(new Duration(seconds: 180), (timer) {
        myInterstitial
          ..load()
          ..show();
      });
    });

    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: HomeScreen(),
    );
  }
}
