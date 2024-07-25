import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fab_analytics/fab_analytics_method_channel.dart';

void main() {
  MethodChannelFabAnalytics platform = MethodChannelFabAnalytics();
  const MethodChannel channel = MethodChannel('fab_analytics');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
