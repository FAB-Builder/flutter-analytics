import 'package:flutter/widgets.dart';

class Config {
  final String applicationId;
  final String clientId;
  final String clientSecret;
  String version;
  dynamic packageInfo;
  bool isDebugMode;
  GlobalKey? appKey;

  // String? server;
  // String? static;
  // String application = "android";

  // String? token = "";
  // String? orderBy = "";
  // int limit = 10;
  // int offset = 0;
  // String? category;

  Config({
    required this.applicationId,
    required this.clientId,
    required this.clientSecret,
    this.version = "",
    required this.packageInfo,
    required this.isDebugMode,
    this.appKey,
  });

  factory Config.fromJson(Map<String, dynamic> json) {
    Config config = Config(
      applicationId: json['applicationId'] ?? "",
      clientId: json['clientId'] ?? "",
      clientSecret: json['clientSecret'] ?? "",
      packageInfo: json['packageInfo'] ?? "",
      isDebugMode: json['isDebugMode'] == "true",
      appKey: json['appKey'],
    );
    // if (json["category"] != null) {
    //   config.category = json["category"];
    // }
    return config;
  }
}
