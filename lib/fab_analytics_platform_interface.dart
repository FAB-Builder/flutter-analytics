import 'package:fab_analytics/models/config_model.dart';
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
    throw UnimplementedError('getPlatformVersion() has not been implemented.');
  }

  Future<void> init(Config config) async {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future trace({
    String? userId,
    required String fromScreen,
    required String toScreen,
    String? action,
    Map? params,
    Config? config,
  }) async {
    throw UnimplementedError('trace() has not been implemented.');
  }
}
