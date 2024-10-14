// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'package:fab_analytics/models/config_model.dart';
import 'package:flutter/widgets.dart';

import 'fab_analytics_platform_interface.dart';

class FabAnalytics {
  Future<String?> getPlatformVersion() {
    return FabAnalyticsPlatform.instance.getPlatformVersion();
  }

  Future<void> init(Config config) async {
    return FabAnalyticsPlatform.instance.init(config);
  }

  // void showScreenshotUploader({
  //   required BuildContext context,
  //   Config? config,
  // }) {
  //   return FabAnalyticsPlatform.instance
  //       .showScreenshotUploader(context: context);
  // }

  Future trace({
    String? userId,
    required String fromScreen,
    required String toScreen,
    String? action,
    Map? params,
    Config? config,
  }) async {
    return FabAnalyticsPlatform.instance.trace(
      userId: userId,
      fromScreen: fromScreen,
      toScreen: toScreen,
      action: action,
      params: params,
    );
  }
}
