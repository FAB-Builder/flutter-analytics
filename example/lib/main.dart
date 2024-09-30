import 'package:fab_analytics/models/config_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:fab_analytics/fab_analytics.dart';
import 'package:package_info_plus/package_info_plus.dart';

// TODO : Add your crdentials
// const applicationId = "";
// const clientId = "";
// const clientSecret = "";
// const version = "";


const applicationId = "66fa85c0c732fab445166d3f";
const clientId = "";
const clientSecret = "";
const version = "";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _fabAnalyticsPlugin = FabAnalytics();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initFabAnalytics();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _fabAnalyticsPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  initFabAnalytics() async {
    Config config = Config(
        applicationId: applicationId,
        clientId: clientId,
        clientSecret: clientSecret,
        version: version);
    try {
      var packageInfo = await PackageInfo.fromPlatform();
      await _fabAnalyticsPlugin.init(config!); // initialize the library
      var response = await _fabAnalyticsPlugin.trace(
          "1234", "fab analytics example", "home", "lauch", packageInfo, null);
      print(response.toString());
    } on PlatformException {
      // Log exception and report studio@gameolive.com
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
