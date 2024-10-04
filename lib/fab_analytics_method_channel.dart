import 'package:fab_analytics/models/config_model.dart';
import 'package:fab_analytics/services/trace_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

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
