import 'package:flutter/widgets.dart';

class Config {
  dynamic credentials;
  dynamic packageInfo;
  bool isDebugMode;
  GlobalKey? appKey;

  static String? token;

  Config({
    required this.credentials,
    // required this.clientId,
    // required this.clientSecret,
    // this.version = "",
    required this.packageInfo,
    required this.isDebugMode,
    this.appKey,
  });

  factory Config.fromJson(Map<String, dynamic> json) {
    Config config = Config(
      credentials: json['keys'] as Map ?? {},
      // clientId: json['clientId'] ?? "",
      // clientSecret: json['clientSecret'] ?? "",
      packageInfo: json['packageInfo'] ?? "",
      isDebugMode: json['isDebugMode'] == "true",
      appKey: json['appKey'],
    );
    if (json["credentials"] != null) {
      config.credentials = json["credentials"];
    }
    return config;
  }
}
