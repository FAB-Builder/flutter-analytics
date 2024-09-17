// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'package:fab_analytics/models/config_model.dart';

import 'fab_analytics_platform_interface.dart';

class FabAnalytics {
  Future<String?> getPlatformVersion() {
    return FabAnalyticsPlatform.instance.getPlatformVersion();
  }

  Future<void> init(Config config) async {
    return FabAnalyticsPlatform.instance.init(config);
  }

  Future trace(String? userId, String fromScreen, String toScreen,
      String action, var packageInfo, Map? params,
      [Config? config]) async {
    return FabAnalyticsPlatform.instance
        .trace(userId, fromScreen, toScreen, action, packageInfo, params);
  }
}
