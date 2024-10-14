import 'package:fab_analytics/models/config_model.dart';
import 'package:fab_analytics/services/trace_service.dart';
import 'package:fab_analytics/widgets/screenshot_upload_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'fab_analytics_platform_interface.dart';

// ignore: non_constant_identifier_names
Config? CONFIG;

/// An implementation of [FabAnalyticsPlatform] that uses method channels.
class MethodChannelFabAnalytics extends FabAnalyticsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fab_analytics');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> init(Config config) async {
    CONFIG = config;
  }

  // @override
  // void showScreenshotUploader({
  //   required BuildContext context,
  //   Config? config,
  // }) {
  //   try {
  //     config ??= CONFIG!;

  //     // Navigator.push(
  //     //   context,
  //     //   MaterialPageRoute(
  //     //     builder: (context) => ScreenShotUploadButton(
  //     //       config: config!,
  //     //       context: context,
  //     //     ),
  //     //   ),
  //     // );
  //     screenshotUploadButton(config, context);
  //   } catch (e) {
  //     print("ERROR showScreenshotUploader ${e.toString()}");
  //   }
  // }

  Future trace({
    String? userId,
    required String fromScreen,
    required String toScreen,
    String? action,
    Map? params,
    Config? config,
  }) async {
    config ??= CONFIG!;
    return doTrace(
      userId ?? "ANONYMOUS",
      fromScreen,
      toScreen,
      action,
      params,
      config,
    );
  }
}
