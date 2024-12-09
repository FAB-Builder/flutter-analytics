import 'dart:convert';
import 'dart:io';
import 'package:fab_analytics/constants.dart';
import 'package:fab_analytics/models/config_model.dart';
import 'package:http/http.dart' as http;

Future doTrace(String? userId, String fromScreen, String toScreen,
    String? action, Map? params, Config config) async {
  try {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    Uri serverUrl = Uri.parse(
        '${constants.API_HOST}/api/tenant/${config.credentials["applicationId"]}/trace/${userId == "" ? "anonymous" : userId}/new');

    String body = jsonEncode({
      "src": fromScreen,
      "dest": toScreen,
      "action": action,
      "params": params,
      "platform": Platform.isAndroid ? "ANDROID" : "IOS",
      "version":
          "${config.packageInfo?.version}-${config.packageInfo?.buildNumber}",
      "packageName": config.packageInfo?.packageName,
    });

    final response = await http.post(serverUrl, headers: headers, body: body);

    // facebookAppEvents.logEvent(
    //   name: 'page_view',
    //   parameters: {
    //     'page_id': fromScreen,
    //   },
    // );

    return response;
  } catch (e) {
    throw Exception(e.toString());
  }
}
