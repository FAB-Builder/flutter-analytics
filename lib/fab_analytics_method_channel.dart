import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fab_analytics_platform_interface.dart';

/// An implementation of [FabAnalyticsPlatform] that uses method channels.
class MethodChannelFabAnalytics extends FabAnalyticsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fab_analytics');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
