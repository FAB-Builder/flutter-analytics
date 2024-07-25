import 'package:flutter_test/flutter_test.dart';
import 'package:fab_analytics/fab_analytics.dart';
import 'package:fab_analytics/fab_analytics_platform_interface.dart';
import 'package:fab_analytics/fab_analytics_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFabAnalyticsPlatform 
    with MockPlatformInterfaceMixin
    implements FabAnalyticsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FabAnalyticsPlatform initialPlatform = FabAnalyticsPlatform.instance;

  test('$MethodChannelFabAnalytics is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFabAnalytics>());
  });

  test('getPlatformVersion', () async {
    FabAnalytics fabAnalyticsPlugin = FabAnalytics();
    MockFabAnalyticsPlatform fakePlatform = MockFabAnalyticsPlatform();
    FabAnalyticsPlatform.instance = fakePlatform;
  
    expect(await fabAnalyticsPlugin.getPlatformVersion(), '42');
  });
}
