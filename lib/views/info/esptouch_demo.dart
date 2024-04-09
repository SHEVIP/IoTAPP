import 'dart:async';

import 'package:esptouch_flutter/esptouch_flutter.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

// TODO: Change this to match your WiFi network. Do not commit. This is a simple demo app, please be careful when handling your passwords.
const ssid = 'Tanklab2';
const bssid = '64:64:4a:b7:b3:42';
const password = 'tanklab12345678';

void executeEsptouch() {
  final task = ESPTouchTask(ssid: ssid, bssid: bssid, password: password);
  final Stream<ESPTouchResult> stream = task.execute();
  final sub = stream.listen((r) => print('IP: ${r.ip} MAC: ${r.bssid}'));
  Future.delayed(Duration(minutes: 1), () => sub.cancel());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Edit constants for WiFi details.'),
              Text('Tap this button and watch the logs'),
              OutlinedButton(
                onPressed: executeEsptouch,
                child: Text('Let\'s go!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}