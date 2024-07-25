import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fab_analytics_method_channel.dart';

abstract class FabAnalyticsPlatform extends PlatformInterface {
  /// Constructs a FabAnalyticsPlatform.
  FabAnalyticsPlatform() : super(token: _token);

  static final Object _token = Object();

  static FabAnalyticsPlatform _instance = MethodChannelFabAnalytics();

  /// The default instance of [FabAnalyticsPlatform] to use.
  ///
  /// Defaults to [MethodChannelFabAnalytics].
  static FabAnalyticsPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FabAnalyticsPlatform] when
  /// they register themselves.
  static set instance(FabAnalyticsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
