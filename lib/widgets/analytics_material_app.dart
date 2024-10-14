import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnalyticsMaterialApp extends StatelessWidget {
  final bool isDebugMode;
  final GlobalKey appKey;
  final Widget materialApp;

  AnalyticsMaterialApp({
    super.key,
    required this.isDebugMode,
    required this.appKey,
    required this.materialApp,
  });

  @override
  Widget build(BuildContext context) {
    return isDebugMode
        ? RepaintBoundary(
            key: appKey,
            child: materialApp,
          )
        : materialApp;
  }
}
