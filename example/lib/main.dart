import 'package:fab_analytics/models/config_model.dart';
import 'package:fab_analytics/widgets/screenshot_upload_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:fab_analytics/fab_analytics.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:fab_analytics/widgets/analytics_material_app.dart';

final GlobalKey appKey = GlobalKey();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// TODO : Add your crdentials
const applicationId = "66fa85c0c732fab445166d3f";
const clientId = "";
const clientSecret = "";
const version = "";
Config config = Config(
  applicationId: applicationId,
  clientId: clientId,
  clientSecret: clientSecret,
  version: version,
  packageInfo: null,
  isDebugMode: kDebugMode,
  appKey: appKey,
);

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _fabAnalyticsPlugin = FabAnalytics();
  String message = "";

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
    var packageInfo = await PackageInfo.fromPlatform();

    config!.packageInfo = packageInfo;
    try {
      await _fabAnalyticsPlugin.init(config!); // initialize the library
      // _fabAnalyticsPlugin.showScreenshotUploader(context: context);
    } catch (e) {
      print(e.toString());
    }
  }

  trace() async {
    var response = await _fabAnalyticsPlugin.trace(
      userId: "1234", //optional
      fromScreen: "Home",
      toScreen: "toScreen",
      action: "trace_btn_clicked", //optional
      params: {
        "id": "5678",
      }, //optional
    );
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return AnalyticsMaterialApp(
      appKey: appKey,
      isDebugMode: kDebugMode,
      config: config,
      navigatorKey: navigatorKey,
      materialApp: MaterialApp(
        navigatorKey: navigatorKey,
        home: Scaffold(
          // floatingActionButton: ScreenshotUploadButton(config: config!),
          appBar: AppBar(
            title: const Text('FAB Analytics Plugin example app'),
          ),
          body: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Running on: $_platformVersion\n'),
                ElevatedButton(
                  onPressed: () async {
                    var response = await trace();
                    if (response.statusCode == 200) {
                      setState(() {
                        message =
                            "Traced successfully! hop on to your dashboard to view";
                      });
                    }
                  },
                  child: Text('Trace'),
                ),
                message != "" ? Text(message) : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
