import 'package:fab_analytics/fab_analytics.dart';
import 'package:fab_analytics/models/config_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnalyticsMaterialApp extends StatelessWidget {
  final bool isDebugMode;
  final GlobalKey appKey;
  final Widget materialApp;
  final Config config;
  final plugin = FabAnalytics();
  final navigatorKey;

  AnalyticsMaterialApp({
    super.key,
    required this.isDebugMode,
    required this.appKey,
    required this.materialApp,
    required this.config,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return isDebugMode
        ? RepaintBoundary(
            key: appKey,
            child: GestureDetector(
              onLongPress: () {
                plugin.takeScreenshot(
                    context: navigatorKey.currentState!.overlay!.context,
                    config: config);
              },
              child: materialApp,
            ),
          )
        : materialApp;
  }
}
