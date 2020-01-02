import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:google_news/src/ui/home/home_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:rate_my_app/rate_my_app.dart';
// import 'package:store_redirect/store_redirect.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  String _message = '';
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  // RateMyApp rateMyApp = RateMyApp(
  //   preferencesPrefix: 'rateMyApp_',
  //   minDays: 3,
  //   minLaunches: 5,
  //   remindDays: 5,
  //   remindLaunches: 6,
  // );

  // void showRate() {
  //   // var _rateMyApp;
  //   print('SHOWING RATE');
  //   rateMyApp.init().then((_) {
  //     if (rateMyApp.shouldOpenDialog) {
  //       rateMyApp.showRateDialog(
  //         context,
  //         title: 'Rate this app',
  //         message:
  //             'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.',
  //         rateButton: 'RATE',
  //         noButton: 'NO THANKS',
  //         laterButton: 'MAYBE LATER',
  //         listener: (button) {
  //           switch (button) {
  //             case RateMyAppDialogButton.rate:
  //               print('Clicked on "Rate".');
  //               StoreRedirect.redirect(androidAppId: "io.flutter.google_news");
  //               break;
  //             case RateMyAppDialogButton.later:
  //               print('Clicked on "Later".');
  //               break;
  //             case RateMyAppDialogButton.no:
  //               print('Clicked on "No".');
  //               break;
  //           }

  //           return true;
  //         },
  //         ignoreIOS: false,
  //         dialogStyle: DialogStyle(),
  //       );
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    getMessage();
    // showRate();
  }

  void getMessage() {
    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        setState(() => _message = message["notification"]["title"]);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        setState(() => _message = message["notification"]["title"]);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        setState(() => _message = message["notification"]["title"]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-4800441463353851~6558594714')
        .then((response) {
      Timer.periodic(new Duration(seconds: 240), (timer) {
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
